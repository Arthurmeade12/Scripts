package me.arthurmeade12.decliner;
public class evaluation {
    boolean print_vocatives_and_locatives;
    protected String base;
    protected String[][] declension = new String[7][3]; // 7 cases, singular, plural, and spacing
    protected String[] spacing = {" ", " ", " ", " ", "  ", " ", " "}; // spacing for the 7 cases, which can be overriden by subclasses
    protected void eval(String nominative, String genitive, byte decl, char gender) {
        switch (decl) {
        case 2:
            base = genitive.substring(0,genitive.length()-1);
            break;
        case 6:
            base = genitive.substring(0,genitive.length()-3);
            break;
        case 7:
        case 8:
            base = "0";
            break;
        default:
            base = genitive.substring(0,genitive.length()-2);
        }
        declension[0][0] = nominative; // endings exist in 'endings' but this is declension generic and 3rd is 3rd
        declension[0][1] = base + endings[decl][0][1];
        // do nominatives outside since nom.sing isn't predictable
        for (byte k = 0; k <= 1; k++){
            for (byte i = 1; i <= 6; i++) {
                declension[i][k] = base + endings[decl][i][k];
            }
        }
        if (gender == 'n') {
            // we would change this in 'endings' BUT it's static
            declension[3][0] = declension[0][0]; // this fixes the singular
            switch (decl) { // for plurals only
            case 2:
            case 3:
                declension[0][1] = base + "a";
                declension[3][1] = base + "a";
            case 4:
                declension[0][1] = base + "ua";
                declension[3][1] = base + "ua";
            // no neuter 1sts or 5ths
            }
        }
    }
    protected void exceptions(){
        System.out.println("Uh-oh. You called the generic declension class for exceptions.");
        System.out.println("Call one of the sub-classes for its exception method.");
    }
    protected void complete(){
        System.out.println(endings[0][0] + endings[0][2] + endings[0][1]);
        System.out.println(endings[1][0] + endings[1][2] + endings[1][1]);
        System.out.println(endings[2][0] + endings[2][2] + endings[2][1]);
        System.out.println(endings[3][0] + endings[3][2] + endings[3][1]);
        System.out.println(endings[4][0] + endings[4][2] + endings[4][1]);
        if (print_vocatives_and_locatives) {
            System.out.println(endings[5][0] + endings[5][2] + endings[5][1]);
            System.out.println(endings[6][0] + endings[6][2] + endings[6][1]);
        }
    }
}
