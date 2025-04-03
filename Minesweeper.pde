Grid grid = new Grid(10, 10);
boolean alive = true;
public class Grid
{
  ArrayList<Cell> cellsArray = new ArrayList<Cell>();
  Cell[][] cells2dArray;
  int cellsX, cellsY, cellSize;
  // cells X/Y is amount of cells, cellSize is pixel side of each cell
  Grid(int x, int y)
  {
    cellsX = x;
    cellsY = y;
  }



  public void CreateGrid()
  {
    cellSize = floor(width/cellsX);
    cells2dArray = new Cell[cellsY][cellsX];
    int xCount = 0;
    int xCountPos = 0;
    int yCount = 0;
    int yCountPos = 0;

    for (int y = 0; y < cellsY; y++)
    {
      for (int x = 0; x < cellsX; x++) {
        Cell cell = new Cell(xCountPos, yCountPos, cellSize, 0);
        //cell.Draw();
        cellsArray.add(cell);
        cells2dArray[yCount][xCount] = cell;
        xCount++;
        xCountPos+=cellSize;
      }
      xCount = 0;
      xCountPos = 0;
      yCount++;
      yCountPos+=cellSize;
    }
  }

  public void GenerateBombs(int percentChance)
  {
    for (int y = 0; y < cellsY; y++)
    {
      for (int x = 0; x < cellsX; x++)
      {
        if (random(0, 100) < percentChance) GetCell(x, y).contains = 3;
        else GetCell(x, y).contains = 2;
      }
    }
    CalculateSurroundingBombs();
  }

  public void ClearSurroundings(int x, int y)
  {
    println(x + ", "+ y);
    // left and right side
    if (x > 0) if (GetCell(x-1, y).surroundingBombs == 0) GetCell(x-1, y).Clicked();
    if (x < cellsX-1) if (GetCell(x+1, y).surroundingBombs == 0) GetCell(x+1, y).Clicked();
    if (y > 0) {
      if (x > 0) {
        if (GetCell(x-1, y-1).surroundingBombs == 0) GetCell(x-1, y-1).Clicked();
      }
      if (x < cellsX-1) {
        if (GetCell(x+1, y-1).surroundingBombs == 0) GetCell(x+1, y-1).Clicked();
      }
      if (GetCell(x, y-1).surroundingBombs == 0) GetCell(x, y-1).Clicked();
    }

    if (y < cellsY-1) {
      if (x > 0) {
        if (GetCell(x-1, y+1).surroundingBombs == 0) GetCell(x-1, y+1).Clicked();
      }
      if (x < cellsX-1) {
        if (GetCell(x+1, y+1).surroundingBombs == 0) GetCell(x+1, y+1).Clicked();
      }
      if (GetCell(x, y+1).surroundingBombs == 0) GetCell(x, y+1).Clicked();
    }
  }

  public int CheckSurrounding(int x, int y)
  {
    int bombs = 0;
    // left and right side
    if (x > 0) if (GetCell(x-1, y).IsBomb()) bombs++;
    if (x < cellsX-1) if (GetCell(x+1, y).IsBomb()) bombs++;

    if (y > 0) {
      if (x > 0) {
        if (GetCell(x-1, y-1).IsBomb()) bombs++;
      }
      if (x < cellsX-1) {
        if (GetCell(x+1, y-1).IsBomb()) bombs++;
      }
      if (GetCell(x, y-1).IsBomb()) bombs++;
    }

    if (y < cellsY-1) {
      if (x > 0) {
        if (GetCell(x-1, y+1).IsBomb()) bombs++;
      }
      if (x < cellsX-1) {
        if (GetCell(x+1, y+1).IsBomb()) bombs++;
      }
      if (GetCell(x, y+1).IsBomb()) bombs++;
    }
    return bombs;
  }

  public void CalculateSurroundingBombs()
  {
    for (int y = 0; y < cellsY; y++)
    {
      for (int x = 0; x < cellsX; x++)
      {
        GetCell(x, y).surroundingBombs = CheckSurrounding(x, y);
      }
    }
  }

  public void Draw()
  {
    for (int y = 0; y < cellsY; y++)
    {
      for (int x = 0; x < cellsX; x++)
      {
        GetCell(x, y).Draw();
      }
    }
  }


  public Cell GetCell(int x, int y)
  {
    return cells2dArray[y][x];
  }
}

public class Cell // only used for calculating if connect4 happened
{
  int xPos, yPos, contains, cellSize, surroundingBombs, centerOffset; // contains: 0 empty, 1 = bomb, 2 = hidden, 3 = hiddenBomb, 4 = flag
  boolean bomb;
  Cell(int x, int y, int size, int cont) {
    xPos = x;
    yPos = y;
    cellSize = size;
    contains = cont;
    if (contains == 2) {
      bomb = true;
      surroundingBombs = -1;
    } else {
      bomb = false;
      surroundingBombs = 0;
    }
    centerOffset = cellSize/2;
  }

  boolean IsBomb()
  {
    if (contains == 3) {
      bomb = true;
    } else {
      bomb = false;
    }
    return bomb;
  }

  void Clicked()
  {
    if (contains == 3) contains = 1;
    else if (contains == 2) {
      contains = 0;
      grid.ClearSurroundings(floor((xPos+10)/cellSize), floor((yPos+10)/cellSize));
    }
    if (IsBomb()) alive = false;
  }

  void DrawCellNumber(int num)
  {
    textSize(20); // scale to grid size
    fill(0, 408, 612);

    text("" + num + "", xPos+centerOffset-5, yPos+centerOffset);
  }

  void Draw()
  {

    if (contains == 3) {
      fill(color(200, 50, 50));
    } else if (contains == 0) {
      fill(color(50, 50, 50));
    } else if (contains == 2) {
      fill(color(100, 100, 100));
    }
    square(xPos, yPos, cellSize);
    if ((contains == 0 || contains == 2) && surroundingBombs > 0) DrawCellNumber(surroundingBombs);
  }
}

void mouseClicked()
{
  grid.GetCell(floor(mouseX/grid.cellSize), floor(mouseY/grid.cellSize)).Clicked();
}

void setup()
{
  size(600, 600);
  background(0);
  grid.CreateGrid();
  grid.GenerateBombs(20);
}

void draw()
{
  background(0);
  if (keyPressed && key == 'r') grid.GenerateBombs(20);
  if (alive) {
    grid.Draw();
  }
}
