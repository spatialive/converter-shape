import {Component} from '@angular/core';
import {UploadService} from '../services/upload.service';
import {MessageService} from 'primeng/api';
import {HttpEventType, HttpResponse} from '@angular/common/http';

@Component({
    selector: 'app-upload',
    templateUrl: './upload.component.html',
    styleUrls: ['./upload.component.scss'],
    providers: [MessageService]
})
export class UploadComponent {
    upload: Upload;

    constructor(private uploadService: UploadService, private messageService: MessageService) {
        this.upload = { geojson: '', wkt: [] };
    }

    onUploadPoints(evt) {
        this.uploadService.upload(evt.files[0]).subscribe({
            next: (event: any) => {
                if (event instanceof HttpResponse) {
                    const data = event.body;
                    if (data.hasOwnProperty('geojson')) {
                        this.upload = data;
                        this.messageService.add(
                            {
                                severity: 'success',
                                summary: 'Sucesso',
                                detail: 'Upload realizado com sucesso',
                                life: 3000
                            }
                        );
                    }
                }
            },
            error: (err: any) => {
                this.messageService.add({
                    severity: 'error',
                    summary: 'Erro no upload do arquivo',
                    detail: err,
                    life: 3000
                });
            }
        });
    }
    clearMap() {
        this.upload = { geojson: '', wkt: [] };
    }
}
export interface Upload {
    geojson: string;
    wkt: string[];
}
