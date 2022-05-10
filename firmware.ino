
void setup() {
  Serial.begin(115200);
}

void loop() {
  int EMG = analogRead(A0);
  int FSR = analogRead(A1); 
  Serial.print(FSR);
  Serial.print(",");
  Serial.print(EMG);
  Serial.print(",\n");
  delay(300);
}
