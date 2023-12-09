package me.arthurmeade12.decliner;
public class fourth extends eval {
    public static final String[][] endings = {
        {"us", "us", " "}, // nominative // set sing. to 0 to match other declensions
        {"us", "uum", " "}, // genitive
        {"ui", "ibus", " "}, // dative
        {"um", "us", " "}, // accusative
        {"u", "ibus", "  "}, // ablative // see comment for dative plural
        {"us", "us", " "}, // vocative // vocative exceptions in exceptions()
        {"us", "ibus", " "} // locative
    };
    fourth(String nom, String gen) {
        super(nom, gen);
        super.makedecl(endings);
    }
    @Override
    public void exceptions() {
        if (gender == 'n') {
            declension[2][0] = declension[0][0];
            declension[0][1] = base + "ua";
            declension[3][1] = base + "ua";
            declension[0][2] = "  ";
            declension[2][2] = "  ";
            declension[3][2] = "  ";
        }
        if (declension[0][0] == "domus") {
            declension[2][0] = "domo";
            declension[6][0] = "domi";
        }
    }
}
