package me.arthurmeade12.decliner;
public class first extends eval {
    public static final String[][] endings = {
        {"a", "ae"}, // nominative // set sing. to 0 to match other declensions
        {"ae", "arum"}, // genitive
        {"ae", "is"}, // dative // don't need potential for abus - these are generic endings
        {"am", "as"}, // accusative
        {"ā", "is"}, // ablative // see comment for dative plural
        {"a", "ae"}, // vocative
        {"ae", "is"} // locative // need to mirror to abl. plur if that changes
    };
    public static final byte num = 1;
    first(String nom, String gen) {
        super(nom, gen, num);
        super.makedecl(endings);
    }
    @Override
    public void exceptions() {
        switch (nom) {
        case "dea":
        case "filia":
            declension[2][1] = base + "abus";
            declension[4][1] = base + "abus";
            break;
        }
    }
}
