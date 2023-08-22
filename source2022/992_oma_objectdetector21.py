from imageai.Detection import ObjectDetection
import wget                                  
import sys                                   
print("this first line fine")                
                                             
                                             
def GraphViz(node):                                           
    d = Graph(node)                                           
                                                              
    from graphviz import Digraph                              
    dot = Digraph("Graph", strict=False)                      
    dot.format = "png"                                        
                                                              
    def rec(nodes, parent):                                   
        for d in nodes:                                       
            if not isinstance(d, dict):                       
                dot.node(d, shape=d._graphvizshape)           
                dot.edge(d, parent)                           
            else:                                             
                for k in d:                                   
                    dot.node(k._name, shape=k._graphvizshape) 
                    rec(d[k], k)                              
                    dot.edge(k._name, parent._name)           
    for k in d:                                               
        dot.node(k._name, shape=k._graphvizshape)             
        rec(d[k], k)                                          
    return dot                                                
                                                              
                                                              
detector = ObjectDetection()                                  
                                                              
url = "http://www.kleiner.ch/images/italo_max_train.jpg"      
url="https://softwareschulecode.files.wordpress.com/2019/12/tee_film4.png?w=750"
destination = "./input/film_tee_train.jpg"                    
                                                              
model_path = "./crypt/yolo-tiny.h5"                    
input_path = "./crypt/gstimage.jpg" #twinwiz.jpg"ekon25web2.png        
                                                                  
#wget.download(url, out=destination) #, useragent= "maXbox")      
#input_path = destination                                         
#output_path = "./crypt/output/manmachine.jpg"                    
output_path = sys.argv[1]                                         
                                                                  
#using the pre-trained TinyYOLOv3 model,                          
detector.setModelTypeAsTinyYOLOv3()                               
detector.setModelPath(model_path)                                 
                                                                  
#loads model of path specified above using setModelPath() class method.   
detector.loadModel()                                                      
                                                                          
custom=detector.CustomObjects(person=True,laptop=True,car=False,train=True,
                       clock=True, chair=False, bottle=False, keyboard=True)
                                                                          
detections=detector.detectCustomObjectsFromImage(custom_objects=custom,  \
                  input_image=input_path, output_image_path=output_path, \
                                     minimum_percentage_probability=40.0) 
                                                                          
for eachItem in detections:                                               
    print(eachItem["name"] ," : ", eachItem["percentage_probability"])    
                                                                          
print("integrate image detector compute ends...") 