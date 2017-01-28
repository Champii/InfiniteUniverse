import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

import {Observable} from 'rxjs/Rx';

@Injectable()
export class Rest {
  http: Http;
  headers = new Headers({ 'Content-Type': 'application/json' });
  options = new RequestOptions({ headers: this.headers });
  baseUrl: string;
  url: string;
  list: any[] = [];
  constructor(http: Http) {
    this.http = http;
    this.baseUrl = '/api/1/';
  }

  find(callback: Function): Observable<any> {
    return this.http.get(this.url, this.options)
      .map((response: Response) => {
        this.list = response.json();
        callback();
        return this.list;
      })
      .catch((error) => {
        return this.handleError(error);
    });
  }

  upload(name: string, file: any): Observable<any> {
    const formData = new FormData();
    const ext = '.' + file.name.split('.').reverse()[0];
    formData.append('file',  file, file.name.split(ext)[0]);

    return this.http.post(this.url, formData)
      .map((response: Response) => {
        const item = response.json();
        this.list.push(item);
        return item;
      })
      .catch((error) => {
        return this.handleError(error);
    });
  }

  create(body): Observable<any> {
      return this.http.post(this.url, JSON.stringify(body), this.options)
        .map((response: Response) => {
          const item = response.json();
          this.list.push(item);
          return item;
        })
        .catch((error) => {
          return this.handleError(error);
      });
  }

  findById(id): Observable<any> {
      return this.http.get(`${this.url}/${id}`, this.options)
        .map((response: Response) => response.json())
        .catch((error) => {
          return this.handleError(error);
      });
  }

  update(body): Observable<any> {
      return this.http.put(`${this.url}/${body.id}`, JSON.stringify(body), this.options)
        // .map((response: Response) => response.json())
        .map((response: Response) => {
          const index = this.list.findIndex(item => item.id === body.id);
          this.list[index] = response.json();
        })
        .catch((error) => {
          return this.handleError(error);
      });
  }

  remove(id: number): Observable<any> {
      return this.http.delete(`${this.url}/${id}`, this.options)
      .map((response: Response) => {
        const index = this.list.findIndex(item => item.id === id);
        this.list.splice(index, 1);
      })
      .catch(this.handleError);
  }

  searchByProperty(property: string, value: any) {
    return this.list.find(item => item[property] === value);
  }

  set(url): void {
    this.url = this.baseUrl + url;
  }

  isEmpty() {
    return !this.list.length;
  }

  private handleError (error: Response | any) {
    // In a real world app, we might use a remote logging infrastructure
    let errMsg: string;
    if (error instanceof Response) {
      const body = error.json() || '';
      const err = body.error || JSON.stringify(body);
      errMsg = `${error.status} - ${error.statusText || ''} ${err}`;
    } else {
      errMsg = error.message ? error.message : error.toString();
    }
    console.error(errMsg);
    return Observable.throw(errMsg);
  }
}
