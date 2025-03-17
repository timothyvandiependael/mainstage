import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { NgFor } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatCheckboxModule } from '@angular/material/checkbox'; // for mat-checkbox
import { MatSelectModule } from '@angular/material/select'; // for mat-select
import { MatOptionModule } from '@angular/material/core'; // for mat-option
import { MatFormFieldModule } from '@angular/material/form-field'; // for mat-form-field
import { MatInputModule } from '@angular/material/input'; // for mat-input

@Component({
  selector: 'app-game-options-dialog',
  imports: [  
    NgFor, 
    FormsModule, 
    MatDialogModule, 
    MatCheckboxModule,
    MatSelectModule, // ✅ Add this
    MatOptionModule, // ✅ Add this for mat-option
    MatFormFieldModule,
    MatInputModule
  ],
  templateUrl: './game-options-dialog.component.html',
  styleUrl: './game-options-dialog.component.css'
})
export class GameOptionsDialogComponent {
  gameOptions = {
    playerAmount: 4,
    turnTimeLimit: 60,
    reactionTimeLimit: 5,
    useMegaFatLady: true,
    aiPlayers: false
  }

  playerAmountOptions: number[] = [ 2, 3, 4 ];
  turnTimeLimitOptions: number[] = [ 30, 60, 120 ];
  reactionTimeLimitOptions: number[] = [ 5, 10, 20 ];

  constructor(
    public dialogRef: MatDialogRef<GameOptionsDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) {}

  confirm() {
    this.dialogRef.close(this.gameOptions);
  }

  cancel() {
    this.dialogRef.close(null);
  }
}
