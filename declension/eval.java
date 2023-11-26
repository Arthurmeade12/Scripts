package me.arthurmeade12.decliner;
import java.lang.Boolean;
public class eval {
    public boolean print_vocatives_and_locatives = false;
    protected String base;
    protected String[][] declension = new String[7][3];
    protected byte decl;
    eval(String nominative, String genitive) { // constructor
        decl = classify.getdecl(nominative, genitive);
        declension[0][0] = nominative;
        base = classify.getbase(genitive, decl);
    }
    protected String[][] makedecl(){
        if (declension [1][0] == null) { // just picked gen. sing randomly, doesn't matter which one (except it can't be nom. sing)
            if (declension[0][1] == null) {
                declension[0][1] = base + endings[0][1]; // nom. plur
            }
            for (byte k = 0; k <= 1; k++){
                for (byte i = 1; i <= 6; i++) {
                    if (declension[i][k] == null) {
                        declension[i][k] = base + endings[i][k];
                    }
                }
            }
            for (byte j = 0; j <= 6; j++) {
                declension[j][2] = " "; // should be overruled by subclasses
            }
        }
        return this.declension;
    }
    void complete(){
        if (boolean.valueOf(declension[1][0]) = null) {
            this.makedecl();
        } // otherwise no need to re-exec code, the array is already set
        System.out.println(declension[0][0] + declension[0][2] + declension[0][1]);
        System.out.println(declension[1][0] + declension[1][2] + declension[1][1]);
        System.out.println(declension[2][0] + declension[2][2] + declension[2][1]);
        System.out.println(declension[3][0] + declension[3][2] + declension[3][1]);
        System.out.println(declension[4][0] + declension[4][2] + declension[4][1]);
        if (print_vocatives_and_locatives) {
            System.out.println(declension[5][0] + declension[5][2] + declension[5][1]);
            System.out.println(declension[6][0] + declension[6][2] + declension[6][1]);
        }
    }
}
