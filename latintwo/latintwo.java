package latintwo;
import java.util.Scanner;
public class latintwo {
    public static void main(String[] args) {
        utils print = new utils();
        print.print("Welcome to Arthur's Conjugator!");
        conjugation voco = new conjugation();
        voco.setup("voco", "vocare", "vocavi", "vocatus");
        voco.exec();
        print.print("Thanks!");
    }
}
