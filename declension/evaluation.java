package me.arthurmeade12.decliner;
public class evaluation {
    boolean print_vocatives_and_locatives;
    protected String base;
    protected String[][] declension = new String[7][2]; // 7*2
    protected static String[][][] endings = {
        {
            {"0"},
            // set 0th index to null so we can refer to the array by declension variable
        },
        {
            {"a", "ae"}, // nominative // set sing. to 0 to match other declensions
            {"ae", "arum"}, // genitive
            {"ae", "is"}, // dative // don't need potential for abus - these are generic endings
            {"am", "as"}, // accusative
            {"ā", "is"}, // ablative // see comment for dative plural
            {"a", "ae"}, // vocative // will make the same as the nominative
            {"ae", "is"} // locative // need to mirror to abl. plur if that changes
        },
        {
            {"us", "i"}, // nominative
            {"i", "orum"}, // genitive
            {"o", "is"}, // dative
            {"um", "os"}, // accusative
            {"o", "is"}, // ablative
            {"e", "i"}, // vocative // will make the same as the nominative
            {"i", "is"} // locative
        },
        {
            {"0", "es"}, // nominative
            {"is", "um"}, // genitive // will eval i-stem
            {"i", "ibus"}, // dative
            {"em", "es"}, // accusative
            {"e", "ibus"}, // ablative
            {"0", "es"}, // vocative // will make the same as the nominative
            {"is", "ibus"} // locative
        },
        {
            {"us", "us"}, // nominative
            {"us", "uum"}, // genitive
            {"ui", "ibus"}, // dative // don't need potential for abus - these are generic endings
            {"um", "us"}, // accusative
            {"u", "ibus"}, // ablative // see comment for dative plural
            {"us", "us"}, // vocative // will make the same as the nominative
            {"us", "ibus"} // locative
        },
        {
            {"es", "es"}, // nominative
            {"ei", "erum"}, // genitive
            {"ei", "ebus"}, // dative // don't need potential for abus - these are generic endings
            {"em", "es"}, // accusative
            {"e", "ebus"}, // ablative // see comment for dative plural
            {"es", "es"}, // vocative // will make the same as the nominative
            {"ei", "ebus"} // locative
        }
    };
    protected void eval(String nominative, String genitive, byte decl, char gender) {
        switch (decl) {
        case 2:
            base = genitive.substring(0,genitive.length()-1);
            break;
        case 6:
            base = genitive.substring(0,genitive.length()-3);
            break;
        case 7:
        case 8:
            base = "0";
            break;
        default:
            base = genitive.substring(0,genitive.length()-2);
        }
        declension[0][0] = nominative; // endings exist in 'endings' but this is declension generic and 3rd is 3rd
        declension[0][1] = base + endings[decl][0][1];
        // do nominatives outside since nom.sing isn't predictable
        for (byte k = 0; k <= 1; k++){
            for (byte i = 1; i <= 6; i++) {
                declension[i][k] = base + endings[decl][i][k];
            }
        }
        if (gender == 'n') {
            // we would change this in 'endings' BUT it's static
            declension[3][0] = declension[0][0]; // this fixes the singular
            switch (decl) { // for plurals only
            case 2:
            case 3:
                declension[0][1] = base + "a";
                declension[3][1] = base + "a";
            case 4:
                declension[0][1] = base + "ua";
                declension[3][1] = base + "ua";
            // no neuter 1sts or 5ths
            }
        }
    }
    // let each declension define it's own 'complete' method for the sake of spacing
}
