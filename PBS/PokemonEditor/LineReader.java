import java.util.ArrayList;

class LineReader {

    private ArrayList<String> lines;
    private int pos;

    public LineReader(ArrayList<String> lines) {
        this.lines = lines;
        pos = 0;
    }

    public boolean hasNextLine() {
        return (pos < lines.size());
    }

    public String nextLine() {
        String line = lines.get(pos);
        pos++;
        return line;
    }

}