//Constantes
final int tam_grid = 15;
final int num_barreiras = 60;
final int valor_robo = -2;
final int valor_destino = -3;
final int valor_barreira = 0;
final int valor_percorrido = -4;

//Matriz feita com hash
public HashMap<Cordenada, Integer> elementos = new HashMap<Cordenada, Integer>();
public LinkedList<Cordenada> melhor_caminho = new LinkedList<Cordenada>();
public int limite;
public boolean achou_destino = false;

//Variáveis do draw
int xRobo, yRobo;
int degrade;
float r, g, b;
color resultado = #B2B2B2; /*
* Começa com a mesma cor do background
* Achou caminho -> Verde
* Nao achou caminho -> Vermelho
*/

//Imagens
PImage DarthVader;
PImage StormTrooper;
PImage DeathStar;
PImage Yoda;
PImage YodaRush;

void setup(){
  size (700, 700);
  
  DarthVader = loadImage("darth_vader.png");
  StormTrooper = loadImage("stormtrooper.png");
  DeathStar = loadImage("estrela_da_morte.png");
  Yoda = loadImage("yoda.png");
  YodaRush = loadImage("yoda_avanço.png");
  
  thread("executa");
}

void executa(){
  Matriz matriz = new Matriz(tam_grid);
  matriz.CriaMapa();
  matriz.WaveFront();
  matriz.Simulacao();
}

void draw(){
  background(#FFFFFF);
  stroke(#10029D);

  float x, y;
  int num_rects = limite; 

  float l = width / (float)num_rects;
  float h = height / (float)num_rects;
  
  for (int i = 0; i < num_rects; i++){
    for (int j = 0; j < num_rects; j++){
      Cordenada pos_rect = new Cordenada(i, j);
      
      x = j * l;
      y = i * h;
      
      if (elementos.containsKey(pos_rect) && elementos.get(pos_rect) == valor_barreira){
        
        fill(resultado);
        
        rect(x, y, l, h);
        image(StormTrooper, x, y, l, h);
        
      } else if (elementos.containsKey(pos_rect) && elementos.get(pos_rect) == valor_destino){
        fill(#B2B2B2);
        
        rect(x, y, l, h);
        image(DarthVader, x, y, l, h);
        
      } else if (elementos.containsKey(pos_rect) && elementos.get(pos_rect) > 0){
        degrade = elementos.get(pos_rect) * 7;

         r = 255 - degrade / 0.85;
         g = 0 + degrade;
         b = 255 - degrade;

        if (g > 22) g = 22;
        
        fill(r, g, b);
        rect(x, y, l, h);
        
        if (tam_grid <= 15){
          fill(255);
          
          textAlign(CENTER, CENTER);
          text(String.format("%d", elementos.get(pos_rect)), x + l / 2, y + h / 2);
        }
      
      } else if (elementos.containsKey(pos_rect) && elementos.get(pos_rect) == valor_percorrido){
        fill(#E0FFDE);
        
        rect(x, y, l, h);
        
      } else {
        
        fill(#B2B2B2);
        rect(x, y, l, h); 
      }
    }
  }
  //Anda com o ROBO
  fill(#B2B2B2);
  rect(xRobo * l, yRobo * h, l, h);
  
  image(Yoda, xRobo * l, yRobo * h, l, h);
}

      
