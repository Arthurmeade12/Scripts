package me.arthurmeade12.decliner;
import java.lang.Boolean;
public class eval {
    protected String[][] declension = new String[7][2];
    protected String[][] endings = new String [7][3];
    public String nominative, genitive;
    eval(String nom, String gen) {
        this.nominative = nom;
        this.genitive = gen;
    }
    protected byte decl = latinutils.getdecl(nominative, genitive);
    protected char gender = latinutils.getgender(nominative, genitive, decl);
    protected String base = latinutils.getbase(genitive, decl);
    public boolean print_vocatives_and_locatives = false;
    protected void makedecl(){
        // will be overriden by subclasses
        msg.die("Do not call the makedecl from outside a subclass.", 1);
    }
    public void complete(){
        // will not be overriden, but needs to be called from subclass. Errors?
        String[][] table = this.declension; // this function checks if  table[][] is already set
        System.out.println(table[0][0] +  table[0][2] +  table[0][1]);
        System.out.println(table[1][0] +  table[1][2] +  table[1][1]);
        System.out.println(table[2][0] +  table[2][2] +  table[2][1]);
        System.out.println(table[3][0] +  table[3][2] +  table[3][1]);
        System.out.println(table[4][0] +  table[4][2] +  table[4][1]);
        if (print_vocatives_and_locatives) {
            System.out.println(table[5][0] +  table[5][2] +  table[5][1]);
            System.out.println(table[6][0] +  table[6][2] +  table[6][1]);
        }
    }
}
