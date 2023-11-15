//
// Decliner by Arthurmeade12 (https://github.com/Arthurmeade12)
// Compiled and tested with Java 17
//
package me.arthurmeade12.decliner;
import java.util.Scanner;
class second extends evaluation {
    protected void second(){
        switch (base) {
        case "fili":
        case "geni":
            declension[5][0] = base;
            break;
        case "de";
            declension[5][0] = declension[0][0];
        case "Ies":
        case "Jes":
        case "ies":
        case "jes":
            declension[5][0] = base + "u";
        }
    }
    protected void complete(String[][] array){
        System.out.println(array[0][0] + "  " + array[0][1]);
        System.out.println(array[1][0] + " " + array[1][1]);
        System.out.println(array[2][0] + " " + array[2][1]);
        System.out.println(array[3][0] + " " + array[3][1]);
        System.out.println(array[4][0] + "  " + array[4][1]);
        if (print_vocatives_and_locatives) {
            System.out.println(array[5][0] + "  " + array[5][1]);
            System.out.println(array[6][0] + " " + array[6][1]);
        }
    }
}
public class main {
    public static void main(String[] args) {
        classify word = new classify();
        if (args.length >= 2) {
            word.nominative = args[0];
            word.genitive = args[1];
            for (int i = 2; i < args.length; i++) {
                System.out.println("WARNING: Argument " + args[i] + " ignored.");
            }
        } else {
            Scanner input = new Scanner(System.in);
            System.out.print("Nominative ? : ");
            word.nominative = input.next();
            System.out.print("Full genitive ? : ");
            word.genitive = input.next();
            input.close();
        }
        byte decl = word.getdecl();
        if (decl == 0) {
            System.exit(1);
        }
        char gender = word.getgender(decl);
        System.out.println("Declension : " + decl);
        System.out.println("Gender : " + gender);
        switch (decl) {
        case 1:
            first exec = new first();
            exec.eval(word.nominative, word.genitive, decl, gender);
            exec.first();
            exec.complete(exec.declension);
            break;
        case 2:

        default:
            System.out.println("uh oh stinky");
        }

    }
}
