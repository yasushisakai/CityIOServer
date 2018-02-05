/**
* Name: CityIOGAMA
* Author: Arnaud Grignard
* Description: This is a template for the CityIO read/write in GAMA 1.7. 
* Tags: grid, load_file, json
*/

model CityIOGAMA

global {
	
	geometry shape <- square(1 #km);
	string cityIOurl <-"https://cityio.media.mit.edu/api/table/fake_table";
    map<string, unknown> matrixData;
    map<int,rgb> buildingColors <-[-2::#red, -1::#orange,0::rgb(189,183,107), 1::rgb(189,183,107), 2::rgb(189,183,107),3::rgb(230,230,230), 4::rgb(230,230,230), 5::rgb(230,230,230),6::rgb(40,40,40),7::#cyan,8::#green,9::#gray];
    map<string, unknown> header;
    map<string, unknown> spatial;
	int refresh <- 100 min: 1 max:1000 parameter: "Refresh rate (cycle):" category: "Grid";
	int matrix_size<-20;
	
	init {
        do initGrid;
	}
	
	action initGrid{
		matrixData <- json_file(cityIOurl).contents;
		spatial <-matrixData["header"]["spatial"];
		header <-matrixData["header"];
		
		loop i from: 0 to: (int(spatial["col"]) -1) {
			loop j from: 0 to: (int(spatial["row"]) -1){
				cityMatrix cell <- cityMatrix grid_at { i, j };
				cell.type<-int(matrixData["grid"][i+j][1]);
				cell.depth<-int(matrixData["grid"][i+j][2]);
			}
        }  
        //save(json_file("https://cityio.media.mit.edu/api/table/update/cityIO_Gama", matrixData));
	}
	
	reflex updateGrid when: ((cycle mod refresh) = 0){
		do initGrid;
	}
}

grid cityMatrix width:matrix_size height:matrix_size {
	int type;
	int depth;
    aspect base{
	  draw shape color:buildingColors[type] depth:depth;
	  draw string(type) color:#black border:#black at:{location.x,location.y,depth+1};		
	}
}

experiment Display  type: gui {
	output {	
		display cityMatrixView  type:opengl  background:#black {
			species cityMatrix aspect:base;
		}
	}
}
