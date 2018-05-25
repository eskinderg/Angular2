import { Component, Input, Output, EventEmitter, ChangeDetectionStrategy } from '@angular/core';
import { Event } from '../../event';

@Component({
  selector: 'app-event-list-item',
  templateUrl: './event-list-item.component.html',
  styleUrls: ['./event-list-item.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class EventListItemComponent {

  @Input() event: Event;

  @Output()
  remove: EventEmitter<Event> = new EventEmitter();

  @Output()
  toggleComplete: EventEmitter<Event> = new EventEmitter();

  constructor() {
  }

  onComplete() {

    this.toggleComplete.emit({
      ...this.event, complete: !this.event.complete
    });

  }

  removeEvent(event: Event) {
    this.remove.emit(event);
  }

}
