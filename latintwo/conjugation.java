package latintwo;
import java.util.Scanner;
public class conjugation {
    public int conjugation = 0;
    public String[] principleparts;
    utils print = new utils();
    public void setup(String first, String second, String third, String  fourth) {
         principleparts = new String[]{"null", first, second, third, fourth}; // so our principle parts will start at 1
        switch (second.substring(second.length()-3)) {
        case "ere":
            Scanner secondorthird = new Scanner(System.in);
            do {
                print.print("Is this second or third conjugation ? (Answer 2 or 3)");
                System.out.print(" : ");
                conjugation = secondorthird.nextInt();
            } while ((conjugation != 2) && (conjugation != 3));
        case "eri":
            conjugation = 2;
        case "are":
        case "ari":
            conjugation = 1;
        case "ire":
        case "iri":
            conjugation = 4;
        default:
            if (second.substring(second.length()-1) == "i") {
                conjugation = 3;
            }
            else {
                print.print("Your verb does not fall into a conjugation.");
                // conjugation = 0; // default
            }
        }
    }
    public void exec() {
        print.print("Conjugation: " + conjugation);
        print.print("Principle Parts: " + principleparts[1] + principleparts[2] +  principleparts[3] + principleparts[4]);
    }
}
