package me.arthurmeade12.decliner;
public class first extends eval {
    public static final String[][] endings = {
        {"a", "ae", "  "}, // nominative // set sing. to 0 to match other declensions
        {"ae", "arum", " "}, // genitive
        {"ae", "is", " "}, // dative // don't need potential for abus - these are generic endings
        {"am", "as", " "}, // accusative
        {"ā", "is", "  "}, // ablative // see comment for dative plural
        {"a", "ae", "  "}, // vocative // will make the same as the nominative
        {"ae", "is", " "} // locative // need to mirror to abl. plur if that changes
    };
    first(String nom, String gen) {
        this.nominative = nom;
        this.genitive = gen;
    }
    @Override
    protected void makedecl() {
        if (declension[1][0] = null) {
            for (byte k = 0; k <= 1; k++){
                for (byte i = 0; i <= 6; i++) {
                    declension[i][k] = base + endings[i][k];
                }
            }
            switch (nominative) {
            case "dea":
            case "filia":
                declension[2][1] = base + "abus";
                declension[4][1] = base + "abus";
                break;
            }
        }
    }
}
