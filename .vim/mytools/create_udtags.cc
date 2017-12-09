/*
 * create_udtags.cc
 *
 * Description:
 *	Create user defined tags
 * Dec,17 2015        Tgni	Created
 *
 * Dec,17 2015	tgni
 *	* Support C/C++/Java tags
 */
#include "iostream"  
#include "string"  
#include "vector"  
#include "sstream"
#include <fstream>  
#include "map"

using namespace std;

//lack of STL knowledge, TODO
//std::map < string, char *> kinds;
char ckinds[] = { 'c', 'd', 'e', 'f', 'g', 'l', 'm', 'n', 'p', 's', 't', 'u', 'v', 'x' };
char javakinds[] = { 'c', 'f', 'i', 'l', 'm', 'p' };

int main(int argc, char *argv[]) 
{
        ifstream ifs;
        ofstream ofs;
        string line;
        std::map < int, string > dat;
        int type;
       
        if (argc != 4) {
                cout << "Usage: ./crudt <filetype> <tags> <udtags>.\n" << endl;
                return -1;
        }

        string tmp1 = argv[2];
        string tmp2 = argv[3];
        if((tmp1.find("tags") == -1) || (tmp2.find("udtags") == -1)) {
                cout << "error params.\n" << endl;
                return -1;
        }

        ifs.open(argv[2]);
        ofs.open(argv[3]);

        while (std::getline(ifs, line)) {

                string key = line.substr(0, line.find("\t"));
                if ((key.find("::") != -1) ||
                    (key.find("operator") != -1) ||
                    (key.find("~") != -1))
			continue;

		if ((type = line.find(";\"\t")) == -1)
                        continue;

                type = line[type + 3];
		key += " ";

		/* I want a hashtable to store keys in it, 
		 * and provide find function.
		 * and create dat[type] at the same time.
		 */
		//if (dat[type].find(key) == -1)
		dat[type] += key;
        }

	char *taglist;
	int nr_tag;

	string filetype = argv[1];
	if (filetype == "c" || filetype == "cpp" || filetype == "python") {
		taglist = ckinds; 	
		nr_tag  = sizeof(ckinds);
	} else if (filetype == "java") {
		taglist = javakinds;
		nr_tag  = sizeof(javakinds);
	}
        for (int i = 0; i < nr_tag; i++) {
                ofs << dat[taglist[i]] << endl;
        }
        ofs.flush();
        ofs.close();

        return 0;  
}
