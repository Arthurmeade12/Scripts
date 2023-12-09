package me.arthurmeade12.decliner;
public class second extends eval {
    public static final String[][] endings = {
        {"us", "i", " "}, // nominative // set sing. to 0 to match other declensions
        {"i", "orum", "  "}, // genitive
        {"o", "is", "  "}, // dative
        {"um", "os", " "}, // accusative
        {"o", "is", "  "}, // ablative // see comment for dative plural
        {"e", "i", "  "}, // vocative // vocative exceptions in exceptions()
        {"i", "is", " "} // locative
    };
    second(String nom, String gen) {
        super(nom, gen);
        super.makedecl(endings);
    }
    @Override
    public void exceptions() {
        if (declension[0][0].endsWith("er") || declension[0][0].endsWith("ir")) {
            if (declension[0][0].length() == declension[1][0].length()){
                declension[0][2] = "  ";
            } else if (declension[0][0].length() < declension[1][0].length()){
                int diff = declension[0][1].length() - declension[0][0].length();
                for (byte i = 0; i <= diff; i++){
                    declension[0][2] = declension[0][2] + " ";
                }
            } else {
                msg.warn("TODO 2nd declension spacing");
            }
        }
    }
}
