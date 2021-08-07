import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

public class Parser {

	private String urlString;
	private String html;
	private ArrayList<String> content;
	private ArrayList<String> content2;
	
	public Parser(String url) {
		
		this.urlString = url;
		html = "n/a";
		content = new ArrayList<String>();
		content2 = new ArrayList<String>();
		
	}
	
	public void fetch() {
		
		html = "";
		
		URL url;
		try {
			url = new URL(urlString);
		} catch (MalformedURLException e) {
			System.out.println("Invalid URL");
			return;
		}
		
		BufferedReader in;
		try {
			in = new BufferedReader(
					new InputStreamReader(url.openStream(), "UTF8"));
		} catch (IOException e) {
			System.out.println("Failed to open data stream.");
			return;
		}
		
		String inputLine;
		try {
			while ((inputLine = in.readLine()) != null) {
				html += inputLine;
			}
		} catch (IOException e) {
			System.out.println("Failed to read line from website.");
			return;
		}
		 
	}
	
	public String parseContent() {
		
		content.clear();
		content2.clear();
		
		String raw = html + "";
		raw = raw.substring(raw.indexOf("dump-move"));
		raw = raw.substring(raw.indexOf("pokemon"));
		raw = raw.substring(raw.indexOf(":"));
		raw = raw.substring(0, raw.indexOf("]}]]"));
		
		String pkmn;
		while (raw.contains(",")) {
			pkmn = raw.substring(raw.indexOf("\"") + 1, raw.indexOf(",") - 1);
			raw = raw.substring(raw.indexOf(",") + 1);
			
			addPokemon(pkmn);
		}
		
		pkmn = raw.substring(raw.indexOf("\"") + 1, raw.length() - 1);
		addPokemon(pkmn);
		
		return raw;
		
	}
	
	private void addPokemon(String pkmn) {
		
		pkmn = pkmn.toUpperCase();
		
		if (pkmn.contains("-ALOLA") || pkmn.contains("-SANDY") || pkmn.contains("-TRASH") ||
			pkmn.contains("-MIDNIGHT") || pkmn.contains("-DUSK")) {
			content2.add(pkmn);
		}
		
		if (!(pkmn.contains("-") && !pkmn.contains("HO-OH") && !pkmn.contains("PORYGON"))) {
			pkmn = pkmn.replace("-", "");
			pkmn = pkmn.replace("'", "");
			pkmn = pkmn.replace(":", "");
			pkmn = pkmn.replace(" ", "");
			pkmn = pkmn.replace(".", "");
			content.add(pkmn);
		}
		
	}
	
	public void printHTML() {
		System.out.println(html);
	}
	
	public String getHTML() {
		return html;
	}
	
	public ArrayList<String> getContent() {
		return content;
	}
	
	public ArrayList<String> getContent2() {
		return content2;
	}
	
}
