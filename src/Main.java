import zombie.core.random.RandLua;
import zombie.core.random.RandStandard;
import zombie.pot.POT;

import java.nio.file.Path;
import java.nio.file.Paths;

public class Main {
    public static void main(String[] args) {
        Path baseDir = Paths.get("").toAbsolutePath();
        Path inputPath = (args.length > 0) ? Paths.get(args[0]) : baseDir.resolve("B41");
        Path outputPath = (args.length > 1) ? Paths.get(args[1]) : baseDir.resolve("B42");
        inputPath = inputPath.toAbsolutePath();
        outputPath = outputPath.toAbsolutePath();

        System.out.println("Input path: " + inputPath);
        System.out.println("Output path: " + outputPath);
        System.out.println("=== B41 -> B42 Map Conversion Tool ===");

        long startTime = System.nanoTime();

        try {
            System.out.println("[INIT] Initializing Project Zomboid random generators...");
            RandStandard.INSTANCE.init();
            RandLua.INSTANCE.init();

            System.out.println("[START] Starting conversion...");
            POT pot = new POT();
            pot.convertMapDirectory(inputPath.toString(), outputPath.toString());

            long duration = (System.nanoTime() - startTime) / 1_000_000;
            System.out.println("[DONE] Conversion completed in " + duration + " ms.");
        } catch (Exception e) {
            System.err.println("[ERROR] An exception occurred during conversion:");
            e.printStackTrace();
            System.exit(1);
        }
    }
}
