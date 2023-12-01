import java.util.Arrays;
class permcalc {
    public String[] names = {"owner", "group", "public"};
    public String[] perms = {"read", "write", "execute"};
    public char[] codes = {'r', 'w', 'x'}; // corresponds to perms // must be array of chars
    // Make final to satisfy switch statement in the j loop
    public int length = 3; // read, write, execute
    public int accesses = 3; // owner, group, public
    private int totallength = length*accesses;
    private int index[] = new int[accesses];
    public static boolean debug = false;
    permcalc() {
        for (byte i = 0; i < index.length; i++) {
            index[i] = length*i;
        }
    }
    public static void error(String msg) {
        System.out.println("Error parsing the " + msg);
    }
    public static void debug(String msg) {
        if (debug == true){
            System.out.println("DEBUG: " + msg);
        }
    }
    public int getoctal(String perm){
        if (perm.length() == totallength) {
            // nothing
        } else if (perm.length() == totallength + 1) {
            perm = perm.substring(1);
        } else {
            this.error("permission length (must be " + totallength + ")");
            return 1;
        }
        int[] results = new int[accesses];
        int result;
        for (int k : index) {
            this.debug("k: " + k);
            int access = k/length; // which access we are on (owner, etc.)
            this.debug("Access : " + names[access] + " (" + access + ")");
            for (byte j = 0; j < length; j++) {
                this.debug("j: " + j);
                this.debug("Char: " + perm.charAt(k+j));
                if (perm.charAt(k + j) != '-') {
                    this.debug("trigger 1");
                    if (perm.charAt(k+j) == codes[access]) {
                        results[access] = results[access] + 2^j; // for octal
                        System.out.println("trigger 2");
                    } else {
                        System.out.println("trigger 3");
                        this.error(perms[j] + " permission for " + names[access]);
                    }
                } else {
                    System.out.println("- found");
                }
                // switch (perm.charAt(k + j)){
                // case codes[access]:
                //     results[access] = results[access] + 2^j; // for octal
                //     break;
                // case '-':
                //     break;
                // default:
                //     this.error(perms[j] + " permission for " + names[k]);
                //     break;
                // }
            }
        }
        this.debug("String : " + perm);
        this.debug("Results: " + Arrays.toString(results));
        String end = "";
        for (byte l = 0; l < accesses; l++) {
            end = end + String.valueOf(results[l]);
        }
        return Integer.valueOf(end);
    }
//     public String getString(int octal) {
//         if (octal.length() != accesses) {
//             this.error("argument length must be " + accesses);
//         }
//         String[][] results = new String[accesses][length];
//         char[][] numbers = {
//             (String.valueOf(octal)).toCharArray(),
//
//         }
//
//     }
}
public class permcalcwrapper {
    public static void main(String[] args) {
        permcalc main = new permcalc();
        if (args.length == 1) {
            main.getoctal(args[0]);
        } else if (args.length == 3) {
            String cat = args[0] + args[1] + args[2];
            main.getoctal(cat);
        } else {
            permcalc.error("arguments");
        }
    }
}
