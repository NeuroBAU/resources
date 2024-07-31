
run("Set Measurements...", "  min centroid bounding fit shape area_fraction limit redirect=None decimal=3"); 
run("Analyze Particles...", "display exclude add stack");
run("RGB Color"); 
for(i=0; i<nResults; i++) { 
    x=getResult('X',i); 
    y=getResult('Y',i); 
    d=getResult('Major',i); 
    a = getResult('Angle',i)*PI/180; 
    setColor("blue"); 
    //drawLine(x+(d/2)*cos(a),y-(d/2)*sin(a),x-(d/2)*cos(a),y+(d/2)*sin(a)); 
    drawOval(x-(d/2)*cos(a),y+(d/2)*sin(a),2,2);
    d=getResult('Minor',i); 
    a=a+PI/2; 
    setColor("red"); 
    //drawLine(x+(d/2)*cos(a),y-(d/2)*sin(a),x-(d/2)*cos(a),y+(d/2)*sin(a));
} 