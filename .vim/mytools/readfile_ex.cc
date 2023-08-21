/*
 * readfile_ex.cc
 */
#include "iostream"  
#include "string"  
#include "vector"  
#include "sstream"
#include <fstream>  

using namespace std;

int main(int argc, char *argv[]) 
{
        ifstream ifs;
        string line;
       
        if (argc != 2) {
                return -1;
        }

        string tmp1 = argv[1];
        if (tmp1.find("udtags") == -1) {
                return -1;
        }

        ifs.open(argv[1]);

        while (std::getline(ifs, line)) {
                cout << line << ",";
        }
        cout << endl;

        ifs.close();

        return 0;
}

