import java.util.*;

class Cordenada {
    public int I;
    public int J;

    public Cordenada (int I, int J){
        this.I = I;
        this.J = J;
    }

    @Override
    public int hashCode(){
        final int prime = 31;
        int resultado = 12;

        resultado = prime * resultado + this.I;
        resultado = resultado * this.J;

        return resultado;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;

        Cordenada cordenada = (Cordenada) obj;
        return this.I == cordenada.I && this.J == cordenada.J;
    }
}

public class Matriz {
    final private int[][] deslocamentos = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}};
    
    private Random Xgerador = new Random();
    private Random Ygerador = new Random();
    private boolean chave_existencia;
    private Cordenada destino_cordenada;
    private Cordenada robo_cordenada;

    public Matriz(int tam_grid){
        elementos.clear();
        melhor_caminho.clear();
        limite = tam_grid;
    }

    public void CriaMapa(){
        determina_barreiras();
        determina_robo();
        determina_destino();
    }

    public void WaveFront(){
        BFS();
        if (!achou_destino) return;
        
        boolean eValido = false, terminou_caminho = false;

        LinkedList<Cordenada> adjacentes = new LinkedList<Cordenada>();
        Cordenada aux = new Cordenada(destino_cordenada.I, destino_cordenada.J);
        Cordenada menor, pos_adj;

          melhor_caminho.addFirst(aux);
  
          while (aux != destino_cordenada){
              if (terminou_caminho) break;
  
              for (int[] deslocamento : deslocamentos){
                  int x = aux.J + deslocamento[0], y = aux.I + deslocamento[1];
  
                  pos_adj = new Cordenada(y, x);
                  eValido = (x >= 0 && x < limite) && (y >= 0 && y < limite) && (elementos.containsKey(pos_adj));
  
                  if (eValido && elementos.get(pos_adj) == valor_robo) {
                    adjacentes.add(pos_adj);                  
                    terminou_caminho = true;
                    break;
                  }
                  
                  else if (eValido && elementos.get(pos_adj) > 0) adjacentes.add(pos_adj);
              }
              if (adjacentes.size() > 0){
                menor = adjacentes.getFirst();
                adjacentes.removeFirst();
                while (!(adjacentes.isEmpty())){
                  if (elementos.get(menor) > elementos.get(adjacentes.getFirst())) menor = adjacentes.getFirst();
  
                  adjacentes.removeFirst();
                }  
                melhor_caminho.addFirst(menor);
                aux = menor;
                
              }
          }
    }
    
    public void Simulacao(){
      if (achou_destino){
        print("\n\n Caminho encontrado !!!");
        locomove_robo();
        resultado = #03FA04;
      } else{
        print("\n\n Caminho não encontrado.... (o_o)");
        resultado = #F50C0C;
      }
    }
    
    private void locomove_robo(){
      
      for(int index = 0; index < melhor_caminho.size(); index++){
        
        delay(300);
        
        xRobo = melhor_caminho.get(index).J;
        yRobo = melhor_caminho.get(index).I;
        
        elementos.replace(new Cordenada(yRobo, xRobo), valor_percorrido);
      }
    }
      

    private void BFS(){
        //Variaveis que desempenham papel na animação
        float decremento = 1;
        float valor_delay;
      
        final int valor_inicial = 0;
        boolean eValido = false;

        int[] aux = new int[3];
        LinkedList<int[]> adjacentes = new LinkedList<int[]>();

        adjacentes.add(new int[] {robo_cordenada.I, robo_cordenada.J, valor_inicial});

        while (adjacentes.size() != 0 && !achou_destino){
            decremento += 0.5;

            aux = adjacentes.getFirst();
            adjacentes.removeFirst();
            
            for (int[] deslocamento : deslocamentos){

                int x = aux[1] + deslocamento[0],y = aux[0] + deslocamento[1];
                Cordenada pos_adj = new Cordenada(y, x);
                
                eValido = (x >= 0 && x < limite) && (y >= 0 && y < limite) && (!(elementos.containsKey(pos_adj)));
                
                if (elementos.containsKey(pos_adj) && elementos.get(pos_adj) == valor_destino) {
                    achou_destino = true;
                    break;
                }
                else if (eValido){
                    adjacentes.add(new int[] {y, x, aux[2] + 1});
                    elementos.put(pos_adj, aux[2] + 1);
                }
                
                valor_delay = 1000/decremento;
                delay((int)valor_delay);
            }
        }      
     
        //Prints para observação da matriz no console;
        printa_matriz();
    }


    private void determina_barreiras(){
        int acumulador = 0;
        while (acumulador < num_barreiras){
            Cordenada cordenada = new Cordenada(Xgerador.nextInt(limite), Ygerador.nextInt(limite));

            if (!(elementos.containsKey(cordenada))) {
                elementos.put(cordenada, valor_barreira);
                acumulador++;
            }
        }
    }

    private void determina_robo(){
        chave_existencia = true;
        Cordenada cordenada = new Cordenada(-1, -1);

        while (chave_existencia){
            cordenada = new Cordenada(Xgerador.nextInt(limite), Ygerador.nextInt(limite));
            chave_existencia = elementos.containsKey(cordenada);
        }
        elementos.put(cordenada, valor_robo);
        
        xRobo = cordenada.J;
        yRobo = cordenada.I;
        
        robo_cordenada = new Cordenada(cordenada.I, cordenada.J);
    }

    private void determina_destino(){
        chave_existencia = true;
        Cordenada cordenada = new Cordenada(-1, -1);

        while (chave_existencia){
            cordenada = new Cordenada(Xgerador.nextInt(limite), Ygerador.nextInt(limite));
            chave_existencia = elementos.containsKey((cordenada));
        }
        elementos.put(cordenada, valor_destino);
        destino_cordenada = new Cordenada(cordenada.I, cordenada.J);
    }
    
    private void printa_matriz(){
      for (int i = 0; i < limite; i++){
       for(int j = 0; j < limite; j++){
         if (elementos.containsKey(new Cordenada(i, j)) && elementos.get(new Cordenada(i, j)) == null) print("?? ");
         else if (elementos.containsKey(new Cordenada(i, j))) print (String.format("%2d ", elementos.get(new Cordenada(i, j))));
         else print ("-1 ");
       }
       println("");
     }
    }
}
