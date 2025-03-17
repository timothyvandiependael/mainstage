import { Component, EventEmitter, Input, Output } from '@angular/core';
import { NgIf, NgFor } from '@angular/common';

export interface ActionPopupData {
  type: string;
  value: string;
  options?: any[];
  description: string;
}

@Component({
  selector: 'app-action-popup',
  imports: [ NgIf, NgFor ],
  templateUrl: './action-popup.component.html',
  styleUrl: './action-popup.component.css'
})
export class ActionPopupComponent {
  @Input() data: ActionPopupData | null = null;
  @Output() actionSelected = new EventEmitter<any>();

  selectOption(option: any) {
    this.actionSelected.emit(option);
  }
}
