package me.arthurmeade12.decliner;
public class fifth extends eval {
    public static final String[][] endings = {
        {"es", "es", " "}, // nominative // set sing. to 0 to match other declensions
        {"ei", "erum", " "}, // genitive
        {"ei", "ebus", " "}, // dative
        {"em", "es", " "}, // accusative
        {"e", "ebus", "  "}, // ablative // see comment for dative plural
        {"es", "es", " "}, // vocative // vocative exceptions in exceptions()
        {"ei", "ibus", " "} // locative
    };
    fifth(String nom, String gen) {
        super(nom, gen);
        super.makedecl(endings);
    }
    @Override // even though there are no exceptions we still need to override to prevent the eval class from complaining
    public void exceptions(){}
}
