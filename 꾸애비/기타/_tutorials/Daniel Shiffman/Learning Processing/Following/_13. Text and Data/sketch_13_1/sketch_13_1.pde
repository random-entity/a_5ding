size(600, 400);
background(0);
String s = "shit!!!!! guhaejwueo";
PFont f = createFont("Georgia", 64);
textFont(f);
textSize(64);
text(s, 10, 100);

float x = 10;
text(s, 10, 300);
for (int i = 0; i < s.length(); i++) {
  char c = s.charAt(i);
  text(c, x, 300);
  x += textWidth(c);
}
