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
            msg.out("Nominative ?");
            nom = input.next();
            msg.out("Full genitive ?");
            gen = input.next();
            input.close();
        }
        System.out.println("");
        switch (latinutils.getdecl(nom, gen)) {
        case 1:
            first execfirst = new first(nom, gen);
            msg.out("Gender : " + execfirst.gender);
            execfirst.complete();
            break;
        case 2:
            second execsecond = new second(nom, gen);
            msg.out("Gender : " + execsecond.gender);
            execsecond.complete();
            break;
        case 4:
            fourth execfourth = new fourth(nom, gen);
            msg.out("Gender : " + execfourth.gender);
            execfourth.complete();
            break;
        case 5:
            fifth execfifth = new fifth(nom, gen);
            msg.out("Gender : " + execfifth.gender);
            execfifth.complete();
            break;
        default:
            msg.warn("Not done yet");
            break;
        }
    }
}
