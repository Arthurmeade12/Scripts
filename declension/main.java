//
// Decliner by Arthurmeade12 (https://github.com/Arthurmeade12)
// Compiled and tested with Java 17
// MIT License
//
package me.arthurmeade12.decliner;
import java.util.Scanner;
public class main {
    public static void main(String[] args) {
        String nom, gen;
        if (args.length >= 2) {
            nom = args[0];
            gen = args[1];
            for (int i = 2; i < args.length; i++) {
                msg.warn("Argument " + args[i] + " ignored.");
            }
        } else {
            Scanner input = new Scanner(System.in);
            msg.out("Nominative ? : ");
            nom = input.next();
            msg.out("Full genitive ? : ");
            gen = input.next();
            input.close();
        }
        switch (latinutils.getdecl(nom, gen)) {
        case 1:
            first exec = new first(nom, gen);
            break;
        default:
            msg.warn("Not done yet");
            break;
        }
    }
}
