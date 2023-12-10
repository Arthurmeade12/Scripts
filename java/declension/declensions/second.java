package me.arthurmeade12.decliner;
public class second extends eval {
    public static final String[][] endings = {
        {"us", "i"}, // nominative // set sing. to 0 to match other declensions
        {"i", "orum"}, // genitive
        {"o", "is"}, // dative
        {"um", "os"}, // accusative
        {"o", "is"}, // ablative
        {"e", "i"}, // vocative // vocative exceptions in exceptions()
        {"i", "is"} // locative
    };
    public static final byte num = 2;
    second(String nom, String gen) {
        super(nom, gen, num);
        super.makedecl(endings);
    }
    @Override
    public void exceptions() {}
}
