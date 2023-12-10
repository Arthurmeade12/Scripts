package me.arthurmeade12.decliner;
import java.util.Scanner;
public class latinutils {
    public static boolean case_sensitive = true;
    public static byte getdecl(String nominative, String genitive) {
        String temp = genitive.substring(genitive.length()-2);
        String ending = temp.toLowerCase();
        temp = null;
        byte error = 0;
        switch (ending) {
        case "ae":
            if (nominative.endsWith("a")) {
                return 1;
            } else {
                error = 1;
            }
        case "is":
            return 3;
        case "us":
            switch (genitive) {
            case "ejus":
                return 6;
            case "cujus":
                return 7;
            case "hujus":
                return 8;
            default:
                if (genitive.endsWith("ius")) {
                    return 6;
                }
                if (nominative.endsWith("u") || nominative.endsWith("us")) {
                    return 4;
                } else {
                    error = 4;
                }
            }
        case "ei":
            if (nominative.endsWith("es")) {
                return 5;
            } else {
                error = 5;
            }
        default:
            if (genitive.endsWith("i")) {
                // TODO: vir does not match these criteria
                if (nominative.endsWith("us") || nominative.endsWith("um") || nominative.endsWith("er") || nominative.endsWith("ir")) {
                    return 2;
                    // will figure out base w/ or w/o e in second class
                } else {
                    System.out.println(nominative + " does not fall into declension #2. ");
                    return 0;
                }
            } else {
                if (error > 0) {
                    msg.warn(nominative + " does not fall into declension #" + error + ". ");
                } else {
                    msg.warn(nominative + " does not fall into any declension. ");
                }
                return 0;
                // 0 for errors (not falling into a declension)
            }
        }
    }
    public static String getbase(String genitive, byte decl) {
        switch (decl) {
        case 1:
        case 3:
        case 4:
        case 5:
            return genitive.substring(0, genitive.length() - 2);
        case 2:
            return genitive.substring(0, genitive.length() - 1);
        case 6:
            return genitive.substring(0, genitive.length() - 3);
        case 7:
        case 8:
            return "";
        default:
            return "0";
        }
    }
    public static char getgender(String nominative, String genitive, byte decl) {
        switch (decl) {
        case 1:
            switch (nominative) {
            case "poeta":
            case "agricola":
            case "incola":
            case "nauta":
                return 'm';
            default:
                return 'f';
            }
            // no neuter 1sts
        case 2:
            if (nominative.endsWith("um")) {
                return 'n';
            } else {
                switch (nominative) {
                case "alvus":
                case "carbasus":
                case "colus":
                case "humus":
                case "vannus":
                case "arctus":
                case "methodus":
                    // feminine 2nds taken from https://dcc.dickinson.edu/grammar/latin/2nd-declension-stem-paradigm-and-gender
                    return 'f';
                // the same webpage has -us neuters BUT they're few & weird
                default:
                    return 'm';
                }
            }
        case 3:
            // here we go (!!)
            if ((nominative == "mare") || (nominative.endsWith("men") && genitive.endsWith("minis")) || (nominative.endsWith("us") && genitive.endsWith("oris"))) {
                return 'n';
            } else if ((nominative.endsWith("tas") && genitive.endsWith("tatis")) || (nominative.endsWith("tus") && genitive.endsWith("tudis"))) {
                return 'f';
            } else {
                msg.out("What is the gender of " + nominative + " ?");
                msg.out("m for masculine, f for feminine, n for neuter : ");
                Scanner genthird = new Scanner(System.in);
                char ans = ' ';
                for (byte i = 1; i > 0; i++) {
                    ans = genthird.next().charAt(0);
                    switch (ans) {
                    case 'm':
                    case 'f':
                    case 'n':
                        return ans;
                    case 'M':
                    case 'F':
                    case 'N':
                        return Character.toLowerCase(ans);
                    default:
                        if (i == 3) {
                            msg.die("Three incorrect attempts. ", 2);
                        } else {
                            msg.warn("Invalid answer. Choose m, f, or n");
                        }
                    }
                }
                return ans;
            }
        case 4:
            if (nominative.endsWith("u")) {
                return 'n';
            } else {
                switch (nominative) {
                case "acus":
                case "anus":
                case "colus":
                case "domus":
                case "manus":
                case "nurus":
                case "porticus":
                case "quinquatrus":
                case "socrus":
                case "tribus":
                    // This list of feminines taken from https://dcc.dickinson.edu/grammar/latin/4th-declension-stem-paradigm-and-gender
                    return 'f';
                default:
                    return 'm';
                }
            }
        case 5:
            if (nominative.endsWith("dies")) {
                return 'm';
            } else {
                return 'f';
            }
        case 8:
            // hic haec hoc
            switch (nominative) {
            case "hic":
                return 'm';
            case "haec":
                return 'f';
            case "hoc":
                return 'n';
            }
        default:
            return '0';
        }
    }
}
