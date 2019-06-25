# Begin Process End

**PipelineTo-Loop** - Run Begin - Process All - Run End  
**PipelineTo-LoopArray** - Run Begin - Process Array as object - Need ForEach in Process - Run End 


## PipelineTo-Loop  
**Case 1 Array as parameters / Wait for String**  
**Call :**  
PipelineTo-Loop -Source 1..10  
  
**Result :**  
Begin Data  
Processing source N°: 1..10   
End Data  


**Case 2 Array as pipeline + Foreach  / Wait for String**  
**Call :**  
 1..10 | ForEach-Object { PipelineTo-Loop -Source $_ }  

**Result :**  
Begin Data  
Processing source N°: 1  
End Data  
Begin Data  
Processing source N°: 2  
End Data  
Begin Data  
Non pas la source N°: 3  
End Data  
Begin Data  
Processing source N°: 4  
End Data  
Begin Data  
Processing source N°: 5  
End Data  


**Case 3 Array as pipeline  / Wait for String**  
**Call :**  
1..10 | PipelineTo-Loop  

**Result :**  
Begin Data    
Processing source N°: 1    
Processing source N°: 2    
Non pas la source N°: 3  
Processing source N°: 4   
Processing source N°: 5  
End Data  



## PipelineTo-LoopArray
**Case 1 Array as parameters + Foreach inside Process / Wait for Array**  
**Call :**  
$Array = 1..10  
PipelineTo-LoopArray -Source $Array  

**Result :**  
Begin Data    
Processing source N°: 1    
Processing source N°: 2    
Non pas la source N°: 3  
Processing source N°: 4   
Processing source N°: 5  
End Data  


