import java.util.Scanner;
class latin {
    public static void warn (String decl) {
        System.out.println("Uh-oh. The word you entered does not conform to the " + decl + " declension.");
    }
    public static void first (String nom, String dp, boolean voc) {
        String base = nom.substring(0, nom.length()-1);
        System.out.println(base + "a  " + base + "ae"); // nominative
        System.out.println(base + "ae " + base + "arum"); // genitive
        System.out.println(base + "ae " + base + dp); // dative
        System.out.println(base + "am " + base + "as"); // accusative
        System.out.println(base + "ā  " + base + "is"); // ablative
        if (voc) {
            System.out.println(base + "a " + base + "ae"); // vocative
        }
    }
    public static void secondmasc (String nom, String base, String spacing, boolean voc) {
        String nspace = "  "; // So compiler doesn't complain. We ensure that one of these conditions will always be met.
        switch (spacing) {
        case "ri":
            break;
        case "eri":
            nspace = "   ";
            break;
        case "us":
            nspace = " ";
        }
        System.out.println(nom + nspace + base + "i"); // nominative
        System.out.println(base + "i  " + base + "orum"); // genitive
        System.out.println(base + "o  " + base + "is"); // dative
        System.out.println(base + "um " + base + "os"); // accusative
        System.out.println(base + "o  " + base + "is"); // ablative
        if (voc) {
            System.out.println(base + "e  " + base + "i"); // vocative
        }
    }
    public static void secondneuter (String nom, boolean voc) {
        String base = nom.substring(0, nom.length()-2);
        System.out.println(nom + " " + base + "a"); // nominative
        System.out.println(base + "i  " + base + "orum"); // genitive
        System.out.println(base + "o  " + base + "is"); // dative
        System.out.println(base + "um " + base + "a"); // accusative
        System.out.println(base + "o  " + base + "is"); // ablative
        if (voc) {
            System.out.println(nom + " " + base + "a"); // vocative
        }
    }
    public static void main(String args[]) {
        String nominative, genitive, vocativeq;
        boolean vocative;
        System.out.println("Welcome to Arthur's decliner!" + "\nType 'exit' to exit.");
        System.out.println("IMPORTANT: This decliner can only accept the complete genitives of 3rd declension nouns.");
        Scanner input = new Scanner(System.in);
        System.out.print("Do you want this script to print vocatives for this session ? (yes or no) : ");
        vocativeq = input.next();
        System.out.println(vocativeq);
        if (vocativeq == "yes") {
            vocative = true;
            System.out.println("Printing vocatives for this session.");
        }
        else {
            vocative = false;
            System.out.println("Leaving out vocatives (default).");
        }
        vocativeq = null;
        while(true) {
            System.out.print("Please type the nominative : ");
            nominative = input.next();
            System.out.println("test");
            if (nominative == "exit") {
                System.out.println("Goodbye!");
                break;
            }
            else if (nominative.length() < 1) {
                System.out.println("You did not enter any characters.");
                continue;
            }
            System.out.print("Write out the genitive, or give an ending (ae for 1st, i for 2nd, etc.) : ");
            genitive = input.next();
            System.out.println(nominative + " & " + genitive);
            if (genitive == "ae") { // || (genitive.substring(genitive.length() - 2) == "ae")
                if (nominative.substring(nominative.length()-1) != "a") {
                    warn("1st");
                    continue;
                }
                String dativeplural;
                switch (nominative) {
                case "filia":
                case "dea":
                    dativeplural = "abus";
                    break;
                default:
                    dativeplural = "is";
                }
                first(nominative, dativeplural, vocative);
            }
            else if (genitive == "i") { //  || genitive.substring(genitive.length() - 1) == "i")
                if (nominative.length() < 2) {
                    warn("2nd");
                    continue;
                }
                String nomending = nominative.substring(nominative.length()-2);
                String base = nominative.substring(0, nominative.length()-2);
                String spacing = "us"; // Initialize this as empty so compiler doesn't complain
                boolean doublespaces = false;
                switch (nomending) {
                case "um":
                    secondneuter(nominative, vocative);
                    continue;
                case "ir":
                    base = nominative;
                    spacing = "eri"; // has same spacing as er 2nds that dont drop the e, no need for seperate designation
                    break;
                case "er":
                    if (genitive != "i") {
                        base = nominative.substring(0, nominative.length()-1); // just drop the i. we are given the entire genitive
                    }
                    else {
                        // We have to figure out the base the hard way.
                        String drop_e_base = base + "r";
                        System.out.println("Is the genitive " + drop_e_base + "i or " + nominative + "i ? " );
                        System.out.print("Answer 1 for the 1st or 2 for the second : ");
                        int base_q = input.nextInt(); // base_q for "base question".
                        switch (base_q) {
                        case 1:
                            base = drop_e_base;
                            spacing = "ri";
                            break;
                        case 2:
                            base = nominative;
                            spacing = "eri";
                            break;
                        }
                    }
                    break;
                case "us":
                    break;
                default:
                    warn("2nd");
                    continue;
                }
                secondmasc(nominative, base, spacing, vocative);
            }
            else {
                System.out.println("Only 1st and 2nd declension are complete so far.");
                System.out.println("Nominative : " + nominative + "\nGenitive : " + genitive);
            }
        }
        input.close();
    }
}
