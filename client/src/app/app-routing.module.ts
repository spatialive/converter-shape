import {RouterModule} from '@angular/router';
import {NgModule} from '@angular/core';
import {UploadComponent} from './upload/upload.component';

@NgModule({
    imports: [
        RouterModule.forRoot([
            {
                path: '', component: UploadComponent,
            },
            {path: '**', redirectTo: '/notfound'},
        ], {scrollPositionRestoration: 'enabled'})
    ],
    exports: [RouterModule]
})

export class AppRoutingModule {
}
