import java.io.*;
import java.net.Socket;
import java.util.ArrayList;

/**
 * Created with IntelliJ IDEA.
 * User: d.aoki
 * Date: 12/05/28
 * Time: 21:30
 * Simple HTTP Client for ex. 605
 */
public class wcat {
    public static void main(String args[]) {
        String host = args[0];
        int port = Integer.valueOf(args[1]);
        String file = args[2];

        try {
            Socket s = new Socket(host, port);
            BufferedWriter bw = new BufferedWriter((new OutputStreamWriter(s.getOutputStream())));
            BufferedReader br = new BufferedReader((new InputStreamReader(s.getInputStream())));

            ArrayList<String> response = new ArrayList<String>();

            bw.write("GET /" + file + " HTTP/1.1\r\n");
            bw.write("Host: " + host + "\r\n\r\n");
            bw.flush();

            while(true) {
                String line = br.readLine();
                if(line == null) {
                    break;
                }
                response.add(line);
            }

            for(String line : response) {
                System.out.println(line);
            }

            br.close();
            bw.close();
            s.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
