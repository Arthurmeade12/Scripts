package me.arthurmeade12.decliner;
import java.lang.Boolean;
public class eval {
    public boolean print_vocatives_and_locatives = false;
    protected String[][] declension = new String[7][3];
    protected String base;
    char gender;
    protected byte decl;
    eval(String nom, String gen) {
        declension[0][0] = nom;
        decl = latinutils.getdecl(nom, gen);
        base = latinutils.getbase(gen, decl);
        gender = latinutils.getgender(nom, gen, decl);
    }
    protected void exceptions(){
        msg.die("Call this from the subclass.", 1);
    }
    protected void makedecl(String[][] endings){
        for (byte i = 1; i <= 6; i++) { // skip nominative bc its weird in 3rd
            declension[i][2] = endings[i][2];
            for (byte k = 0; k <= 1; k++){
                declension[i][k] = base + endings[i][k];
            }
        }
        declension[0][2] = endings[0][2];
        // nom.sing already set
        declension[0][1] = base + endings[0][1];
        if (gender == 'n'){
            declension[3][0] = declension[0][0]; // nom = acc
            declension[0][1] = base + "a";
            declension[3][1] = base + "a";
        }
        this.exceptions();
    }
    public void complete(){
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
