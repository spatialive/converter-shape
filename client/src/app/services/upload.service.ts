import {Injectable} from '@angular/core';
import {HttpClient, HttpErrorResponse, HttpEvent, HttpHeaders, HttpRequest} from '@angular/common/http';
import {Observable, throwError} from 'rxjs';
import {catchError} from 'rxjs/operators';
import {environment} from '../../environments/environment';
@Injectable({
    providedIn: 'root',
})

export class UploadService {

    private apiURL = environment.SERVER_URL + '/api/upload/file';

    httpOptions = {
        headers: new HttpHeaders({
            'Content-Type': 'multipart/form-data'
        }),
    };

    constructor(private httpClient: HttpClient) {}

    upload(file: File): Observable<any> {
        const formData: FormData = new FormData();

        formData.append('file', file);
        const req = new HttpRequest('POST', this.apiURL, formData, {
            reportProgress: false,
            responseType: 'json'
        });

        return this.httpClient.request(req)
            .pipe(catchError(this.errorHandler),
        );
    }
    errorHandler(error: HttpErrorResponse) {
        const errorMessage = `Código do erro: ${error.status} - Mensagem: ${JSON.stringify(error)}`;
        return throwError(errorMessage);
    }
}
