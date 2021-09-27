import { Injectable, OnInit } from '@angular/core';
import * as signalR from '@microsoft/signalr';
import { HttpClient } from '@angular/common/http';
import { Message } from '../models/Message';
import { Observable, Subject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ChatService {

	private connection: any = new signalR.HubConnectionBuilder().withUrl("https://localhost:5001/chatsocket")
										.configureLogging(signalR.LogLevel.Information)
										.build();
	readonly POST_URL = "https://localhost:5001/api/chat/send"

	private receivedMessageObject: Message = new Message();
	private sharedObj = new Subject<Message>();

	constructor(private http: HttpClient) { 
		this.connection.onclose(async () => {
			await this.start();
		});
		this.connection.on("ReceiveOne", (user, message) => { this.mapReceivedMessage(user, message); });
		this.start();                 
	}


  // Start the connection
  public async start() {
    try {
      await this.connection.start();
      console.log("connected");
    } catch (err) {
      console.log(err);
      setTimeout(() => this.start(), 5000);
    } 
  }

  private mapReceivedMessage(user: string, message: string): void {
    this.receivedMessageObject.user = user;
    this.receivedMessageObject.msgText = message;
    this.sharedObj.next(this.receivedMessageObject);
 }

  /* ****************************** Public Mehods **************************************** */

  // Calls the controller method
  public broadcastMessage(msgDto: any) {
    this.http.post(this.POST_URL, msgDto).subscribe(data => console.log(data));
    // this.connection.invoke("SendMessage1", msgDto.user, msgDto.msgText).catch(err => console.error(err));    // This can invoke the server method named as "SendMethod1" directly.
  }

  public retrieveMappedObject(): Observable<Message> {
    return this.sharedObj.asObservable();
  }


}