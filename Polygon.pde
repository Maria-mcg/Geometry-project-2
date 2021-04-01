

class Polygon {
  
   ArrayList<Point> p     = new ArrayList<Point>();
   ArrayList<Edge>  bdry = new ArrayList<Edge>();
     
   Polygon( ){  }
   
   
   boolean isClosed(){ return p.size()>=3; }
   
   
   boolean isSimple(){
     // TODO: Check the boundary to see if it is simple or not.
     //Polygon that does not have an intersection by itself is a simple Polygon
     //Non polygon has instersections with itself
     
     ArrayList<Edge> bdry = getBoundary(); // getting bundary
     int i; 
     // the following code checks the intersection 
     for (i=0; i<bdry.size(); i++)
     {
       int j;
       for (j=0; j<bdry.size(); j++)
       {  
          if (i==j)
           continue; 
     
      if((bdry.get(i).p0.p.x == bdry.get(j).p0.p.x && bdry.get(i).p0.p.y == bdry.get(j).p0.p.y)  || (bdry.get(i).p0.p.x == bdry.get(j).p1.p.x && bdry.get(i).p0.p.y == bdry.get(j).p1.p.y) ||
         (bdry.get(i).p1.p.x == bdry.get(j).p0.p.x && bdry.get(i).p1.p.y == bdry.get(j).p0.p.y) || (bdry.get(i).p1.p.x == bdry.get(j).p1.p.x && bdry.get(i).p1.p.y == bdry.get(j).p1.p.y))
               {continue; }
               
       if (bdry.get(i).intersectionTest( bdry.get(j)) == true)
             return false;
        
       }
     }
     return true;
  }

   




   boolean pointInPolygon( Point p ){
     
     // TODO: Check if the point p is inside of the 
     //this function finds the point in the polygon 
     //I call intersectionTest and optimizedInteresectPoint to solve for it
     ArrayList<Edge> bdry = getBoundary();
     Point x= new Point (p.p.x * 1000, p.p.y);
     int counter = 0;
     Edge e= new Edge(p,x);
     int i;
     for (i=0; i< bdry.size(); i++)
     {
   
       if(e.intersectionTest(bdry.get(i)) == true  && (e.optimizedIntersectionPoint(bdry.get(i)) != bdry.get(i).p0 || e.optimizedIntersectionPoint(bdry.get(i)) != bdry.get(i).p1))
             counter++;
     }
     if (counter%2 != 1)
     return false;
       return true;
       
 
     
     
      
   }
   
  
   
     ArrayList<Edge> getDiagonals(){
     // TODO: Determine which of the potential diagonals are actually diagonals
     //n(n-3)/2
     //this function get the polygon diagnals 
     ArrayList<Edge> bdry = getBoundary();
     ArrayList<Edge> diag = getPotentialDiagonals();
     ArrayList<Edge> ret  = new ArrayList<Edge>();
     
     for(int i=0; i< diag.size(); i++)
     {
       
      int counter1 = 0;
      for(int j = 0;j<bdry.size();j++)
      {
         
         if(!find_Adjancent(diag.get(i),bdry.get(j)) )
         {
           if(diag.get(i).intersectionTest(bdry.get(j))==true) 
                 counter1++;
          
         }
         
      }
      if(counter1>0)
        continue;
      else if (pointInPolygon(diag.get(i).midpoint())==false)
                 continue;
       ret.add(diag.get(i));
         

      
     }
    
     
     return ret ;//return the array
   }
   boolean find_Adjancent(Edge first, Edge second) //function created to solve getDiagonals
   //this function is just created to insert the formula to solve adjancent polygons
   {
      if((first.p0.p.x == second.p0.p.x && first.p0.p.y == second.p0.p.y) || (first.p0.p.x == second.p1.p.x && first.p0.p.y == second.p1.p.y) ||
         (first.p1.p.x == second.p0.p.x && first.p1.p.y == second.p0.p.y) || (first.p1.p.x == second.p1.p.x && first.p1.p.y == second.p1.p.y))
               return true;
               
      return false; 
   }
   
   boolean ccw(){
     // TODO: Determine if the polygon is oriented in a counterclockwise fashion
     
     if( !isClosed() ) return false;
     if( !isSimple() ) return false;
     //float val;
     float Fresult=0;
     float c1;
     float c2;
     float thesum=0;
     ArrayList<Edge> bdry= getBoundary();
     int i;
     for (i=0; i<bdry.size(); i++)
     {
       //formula to get ccw polygon it is simliar logic that Triangle ccw
      Edge var;
      var= bdry.get(i);
      c1= (var.p1.p.x - var.p0.p.x);
      c2= (var.p1.p.y + var.p0.p.y);
      Fresult= c1*c2;
      thesum= thesum+ Fresult;
      
     }
     //counter- clowiise -1
     if (Fresult>0)
     return false;
     else
     return true;
   }
   
   
   boolean cw(){
     // TODO: Determine if the polygon is oriented in a clockwise fashion
     if( !isClosed() ) return false;
     if( !isSimple() ) return false;
      float Fresult=0;
     float c1;
     float c2;
     float thesum=0;
     ArrayList<Edge> bdry= getBoundary();
     int i;
     for (i=0; i<bdry.size(); i++)
     {
      // formula to find cw polygon similar to triangle logic
      Edge var;
      var= bdry.get(i);
      c1= (var.p1.p.x - var.p0.p.x);
      c2= (var.p1.p.y + var.p0.p.y);
      Fresult= c1*c2;
      thesum= thesum+ Fresult;
     }
     if (Fresult < 0)
     return false;
     else return true;
   }
   
   float area(){
     // TODO: Calculate and return the area of the polygon
      float value=0;
      int i;
      if(isClosed())
      
      {
        for (i=0; i<bdry.size()-2; i++)
        {
          Triangle trianglee= new Triangle(p.get(i), p.get(i+1),p.get(i+2));// calling function under triangle file to make it easier to calculate, following the slides
          value= value+ trianglee.area();
        }
       
   }
    return Math.abs(value/2); //using Math helps me to solve the equation faster
   }
   
   
   
   
   
   
   ArrayList<Edge> getBoundary(){
     return bdry;
   }


   ArrayList<Edge> getPotentialDiagonals(){
     ArrayList<Edge> ret = new ArrayList<Edge>();
     int N = p.size();
     for(int i = 0; i < N; i++ ){
       int M = (i==0)?(N-1):(N);
       for(int j = i+2; j < M; j++ ){
         ret.add( new Edge( p.get(i), p.get(j) ) );
       }
     }
     return ret;
   }
   

   void draw(){
     println( bdry.size() );
     for( Edge e : bdry ){
       e.draw();
     }
   }
   
   
   void addPoint( Point _p ){ 
     p.add( _p );
     if( p.size() == 2 ){
       bdry.add( new Edge( p.get(0), p.get(1) ) );
       bdry.add( new Edge( p.get(1), p.get(0) ) );
     }
     if( p.size() > 2 ){
       bdry.set( bdry.size()-1, new Edge( p.get(p.size()-2), p.get(p.size()-1) ) );
       bdry.add( new Edge( p.get(p.size()-1), p.get(0) ) );
     }
   }

}
