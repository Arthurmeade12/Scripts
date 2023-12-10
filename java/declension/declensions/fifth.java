package me.arthurmeade12.decliner;
public class fifth extends eval {
    public static final String[][] endings = {
        {"es", "es"}, // nominative
        {"ei", "erum"}, // genitive
        {"ei", "ebus"}, // dative
        {"em", "es"}, // accusative
        {"e", "ebus"}, // ablative
        {"es", "es"}, // vocative
        {"ei", "ibus"} // locative
    };
    public static final byte num = 5;
    fifth(String nom, String gen) {
        super(nom, gen, num);
        super.makedecl(endings);
    }
    @Override // even though there are no exceptions we still need to override to prevent the eval class from complaining
    public void exceptions(){}
}
