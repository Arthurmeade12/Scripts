package me.arthurmeade12.decliner;
import java.lang.Boolean;
public class eval {
    public boolean print_vocatives_and_locatives = false;
    protected String[][] declension = new String[7][3];
    public String nominative, genitive;
    protected String base;
    protected char gender;
    protected byte decl;
    eval(String nom, String gen) {
        nominative = nom;
        genitive = gen;
        decl = latinutils.getdecl(nominative, genitive);
        base = latinutils.getbase(genitive, decl);
        for (byte i = 0; i < declension.length; i++) {
            for (byte j = 0; j < declension[i].length; j++) {
                declension[i][j] = "";
                // fixes errors with checking for length of null
            }
        }
    }
    private static void callsubclass(){
        msg.die("You can only call this method from a subclass.");
    }
    protected void makedecl(){
        eval.callsubclass();
    }
    public void complete(){
        this.makedecl();
        System.out.println(declension[0][0] +  declension[0][2] +  declension[0][1]);
        System.out.println(declension[1][0] +  declension[1][2] +  declension[1][1]);
        System.out.println(declension[2][0] +  declension[2][2] +  declension[2][1]);
        System.out.println(declension[3][0] +  declension[3][2] +  declension[3][1]);
        System.out.println(declension[4][0] +  declension[4][2] +  declension[4][1]);
        if (print_vocatives_and_locatives) {
            System.out.println(declension[5][0] +  declension[5][2] +  declension[5][1]);
            System.out.println(declension[6][0] +  declension[6][2] +  declension[6][1]);
        }
    }
}
