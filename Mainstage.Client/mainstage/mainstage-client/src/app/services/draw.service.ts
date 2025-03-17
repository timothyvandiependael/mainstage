import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class DrawService {
  playerColors: any[] = [
    'blue',
    'red',
    'green',
    'black'
  ];

  constructor() { }

  drawGameBoard(ctx: CanvasRenderingContext2D, tileSize: number, tiles: any[]) {
    var arial14 = '14px Arial';
    var white = 'white';
    var green = 'green';
    var black = 'black';
    var lightgrey = 'lightgrey';
    var center: CanvasTextAlign = 'center';
    var middle: CanvasTextBaseline = 'middle';

    this.fillRect(ctx, lightgrey, 0, 0, tileSize * 16, tileSize * 22);

    tiles.forEach((tile: any, index: number) => {
      var positionX = tileSize / 2 + (tile.x - 1) * tileSize;
      var positionY = tileSize / 2 + (tile.y - 1) * tileSize;

      if (index == 24) {
        this.fillRect(ctx, white, positionX - tileSize, positionY, tileSize * 2, tileSize * 4);
        this.strokeRect(ctx, black, 1, positionX - tileSize, positionY, tileSize * 2, tileSize * 4);
        this.fillText(ctx, green, arial14, center, middle, '4, 5, 6', positionX, positionY + tileSize * 2);
      }

      if (index == 46) {
        this.fillRect(ctx, 'white', positionX, positionY, tileSize * 2, tileSize * 5);
        this.strokeRect(ctx, 'black', 1, positionX, positionY, tileSize * 2, tileSize * 5);
        this.fillText(ctx, green, arial14, center, middle, '5, 6', positionX + tileSize, positionY + tileSize * 2);
      }

      if (index == 69) {
        this.fillRect(ctx, 'white', positionX - (tileSize * 4), positionY - tileSize, tileSize * 9, tileSize * 3);
        this.strokeRect(ctx, 'black', 1, positionX - (tileSize * 4), positionY - tileSize, tileSize * 9, tileSize * 3);
        this.fillText(ctx, green, arial14, center, middle, '6', positionX + tileSize / 2, positionY + tileSize * 1.5);
      }

      this.fillRect(ctx, tile.hasCard ? 'lightyellow' : 'white', positionX, positionY, tileSize, tileSize);
      this.strokeRect(ctx, 'black', 1, positionX, positionY, tileSize, tileSize);

      if (index == 0) {
        for (var i = 1; i <= 3; i++) {
          positionX += tileSize;
          this.fillRect(ctx, 'white', positionX, positionY, tileSize, tileSize);
          this.strokeRect(ctx, 'black', 1, positionX, positionY, tileSize, tileSize);
        }

        this.fillText(ctx, green, arial14, center, middle, '3, 4, 5, 6', positionX - tileSize, positionY - tileSize / 2);
      }

      if (index != 0) {
        this.fillText(ctx, black, arial14, center, middle, tile.id.toString(), positionX + tileSize / 2, positionY + tileSize / 2);
      }
    });

    debugger;

    var path = [
      { x: 9 * tileSize, y: 18.5 * tileSize },
      { x: 9 * tileSize, y: 17.5 * tileSize }
    ];
    this.drawArrow(ctx, path, 'blue', 2, 10);

    path = [
      { x: 5 * tileSize, y: 12.5 * tileSize },
      { x: 5 * tileSize, y: 15 * tileSize },
      { x: 5.5 * tileSize, y: 15 * tileSize }
    ]
    this.drawArrow(ctx, path, 'blue', 2, 10);

    path = [
      { x: 2.5 * tileSize, y: 11 * tileSize },
      { x: 4 * tileSize, y: 11 * tileSize },
      { x: 4 * tileSize, y: 11.5 * tileSize }
    ]
    this.drawArrow(ctx, path, 'blue', 2, 10);

    var path = [
      { x: 9.5 * tileSize, y: 14 * tileSize },
      { x: 11.5 * tileSize, y: 12 * tileSize }
    ];
    this.drawArrow(ctx, path, 'blue', 2, 10);

    path = [
      { x: 14 * tileSize, y: 11.5 * tileSize },
      { x: 14 * tileSize, y: 13 * tileSize },
      { x: 12.5 * tileSize, y: 13 * tileSize }
    ]
    this.drawArrow(ctx, path, 'blue', 2, 10);

    path = [
      { x: 10 * tileSize, y: 7.5 * tileSize },
      { x: 10 * tileSize, y: 13 * tileSize },
      { x: 9.5 * tileSize, y: 13 * tileSize }
    ]
    this.drawArrow(ctx, path, 'blue', 2, 10);

    var path = [
      { x: 7 * tileSize, y: 9.5 * tileSize },
      { x: 7 * tileSize, y: 10.5 * tileSize }
    ];
    this.drawArrow(ctx, path, 'blue', 2, 10);

    var path = [
      { x: 8 * tileSize, y: 5.5 * tileSize },
      { x: 8 * tileSize, y: 6.5 * tileSize }
    ];
    this.drawArrow(ctx, path, 'blue', 2, 10);

    var path = [
      { x: 6 * tileSize, y: 3.5 * tileSize },
      { x: 6 * tileSize, y: 4.5 * tileSize }
    ];
    this.drawArrow(ctx, path, 'blue', 2, 10);

  }

  async movePawnForward(ctx: CanvasRenderingContext2D, playerIndex: number, currentTile: number, destinationTile: number, tileSize: number, tiles: any[], players: any[]) {
    players[playerIndex].position = currentTile;
    while (players[playerIndex].position < destinationTile) {
      await this.delay(760);
      this.drawGameBoard(ctx, tileSize, tiles);
      players[playerIndex].position++;
      this.drawPawns(ctx, tileSize, players, tiles);
    }
  }

  async movePawnBackward(ctx: CanvasRenderingContext2D, playerIndex: number, currentTile: number, destinationTile: number, tileSize: number, tiles: any[], players: any[]) {
    players[playerIndex].position = currentTile;
    while (players[playerIndex].position > destinationTile) {
      await this.delay(760);
      this.drawGameBoard(ctx, tileSize, tiles);
      players[playerIndex].position--;
      this.drawPawns(ctx, tileSize, players, tiles);
    }
  }

  async teleportPawn(ctx: CanvasRenderingContext2D, playerIndex: number, destinationTile: number, tileSize: number, tiles: any[], players: any[]) {
    await this.delay(760);
    this.drawGameBoard(ctx, tileSize, tiles);
    players[playerIndex].position == destinationTile;
    this.drawPawns(ctx, tileSize, players, tiles);
  }

  delay(ms: number) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  drawPawns(ctx: CanvasRenderingContext2D, tileSize: number, players: any[], tiles: any[]) {
    players.forEach((player, i) => {

      var tile = tiles[player.position];

      var img = new Image();
      img.src = "assets/guitar-" + this.playerColors[i] + '.png';

      if (tile.id == 0) {
        var posX = tileSize / 2 + (tile.x - 1) * tileSize + i * tileSize;
      }
      else {
        var posX = tileSize / 2 + (tile.x - 1) * tileSize;
      }

      var posY = tileSize / 2 + (tile.y - 1) * tileSize;

      img.onload = function () {
        ctx.drawImage(img, posX + tileSize * 0.1, posY + tileSize * 0.1, tileSize * 0.8, tileSize * 0.8);
      }
    });
  }

  fillRect(ctx: CanvasRenderingContext2D, color: string, positionX: number, positionY: number, sizeX: number, sizeY: number) {
    ctx.fillStyle = color;
    ctx.fillRect(positionX, positionY, sizeX, sizeY);
  }

  strokeRect(ctx: CanvasRenderingContext2D, color: string, lineWidth: number, positionX: number, positionY: number, sizeX: number, sizeY: number) {
    ctx.strokeStyle = color;
    ctx.lineWidth = lineWidth;
    ctx.strokeRect(positionX, positionY, sizeX, sizeY);
  }

  fillText(ctx: CanvasRenderingContext2D, color: string, font: string, textAlign: CanvasTextAlign, textBaseline: CanvasTextBaseline,
    text: string, positionX: number, positionY: number) {
    ctx.fillStyle = color;
    ctx.font = font;
    ctx.textAlign = textAlign;
    ctx.textBaseline = textBaseline;
    ctx.fillText(text, positionX, positionY);
  }

  drawArrow(ctx: CanvasRenderingContext2D, path: { x: number, y: number }[], color: string, lineWidth: number, headSize: number = 10) {
    if (path && path.length > 1) {
      ctx.strokeStyle = color;
      ctx.fillStyle = color;
      ctx.lineWidth = lineWidth;

      for (var i = 0; i < path.length - 1; i++) {
        var fromX = path[i].x;
        var toX = path[i + 1].x;
        var fromY = path[i].y;
        var toY = path[i + 1].y;

        const angle = Math.atan2(toY - fromY, toX - fromX);
        ctx.beginPath();
        ctx.moveTo(fromX, fromY);
        ctx.lineTo(toX, toY);
        ctx.stroke();
      }

      var lineEndX = path[path.length - 1].x;
      var lineEndY = path[path.length - 1].y;
      var lineEndAngle = Math.atan2(lineEndY - path[path.length - 2].y, lineEndX - path[path.length - 2].x);

      ctx.beginPath();
      ctx.moveTo(lineEndX, lineEndY);
      ctx.lineTo(
        lineEndX - headSize * Math.cos(lineEndAngle - Math.PI / 6),
        lineEndY - headSize * Math.sin(lineEndAngle - Math.PI / 6)
      );
      ctx.lineTo(
        lineEndX - headSize * Math.cos(lineEndAngle + Math.PI / 6),
        lineEndY - headSize * Math.sin(lineEndAngle + Math.PI / 6)
      );
      ctx.lineTo(lineEndX, lineEndY);
      ctx.fill();
    }
  }
}
