 char val; // Data received from the serial port
 int TTL = 2; // activate PIN #2


 void setup() {
   pinMode(LED_BUILTIN, OUTPUT);
   pinMode(TTL,OUTPUT);
   Serial.begin(9600); // Start serial communication at 9600 bps
 }


 void loop() {
   if (Serial.available()) 
   { // If data is available to read,
     val = Serial.read(); // read it and store it in val
   }
   if (val == '1') 
   { // If 1 was received
         digitalWrite(LED_BUILTIN, HIGH);    // turn the LED off by making the voltage LOW
     digitalWrite(TTL, HIGH);   // turn the LED on (HIGH is the voltage level)
   } else {
     digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
        digitalWrite(TTL, LOW);   // turn the LED on (HIGH is the voltage level)
   }
   delay(10); // Wait 10 milliseconds for next reading
}
