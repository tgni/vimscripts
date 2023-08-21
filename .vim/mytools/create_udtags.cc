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
#include <unordered_set>

using namespace std;

char ckinds[] = { 'c', 'd', 'e', 'f', 'g', 's', 't', 'u', 'v', 'x' };
char javakinds[] = { 'c', 'f', 'i', 'l', 'm', 'p' };
char matlabkinds[] = { 'f'};

int main(int argc, char *argv[]) 
{
	ifstream ifs;
	ofstream ofs;
	string line;
	std::map <int, unordered_set<string>> dat;
	int type;

	if (argc != 4) {
		cout << "Usage: ./crudt <filetype> <tags> <udtags>.\n" << endl;
		return -1;
	}

	string tmp1 = argv[2];
	string tmp2 = argv[3];
	if((tmp1.find("tags") == tmp1.npos) || (tmp2.find("udtags") == tmp2.npos)) {
		cout << "error params.\n" << endl;
		return -1;
	}

	ifs.open(argv[2]);
	ofs.open(argv[3]);

	while (std::getline(ifs, line)) {
		string key = line.substr(0, line.find("\t"));
		if ((key.find("::") != key.npos) || (key.find("operator") != key.npos) || (key.find("~") != key.npos) || (key.find("$") != key.npos))
			continue;
		if ((key.find("contains") != key.npos) || (key.find("oneline") != key.npos) || (key.find("fold") != key.npos) || (key.find("display") != key.npos))
			continue;
		if ((key.find("extend") != key.npos) || (key.find("concealends") != key.npos))
			continue;

		if ((type = line.find(";\"\t")) == -1)
			continue;

		type = line[type + 3];
		dat[type].insert(key);
	}

	char *taglist;
	int nr_tag;

	string filetype = argv[1];
	if (filetype == "c" || filetype == "c++" || filetype == "python") {
		taglist = ckinds;
		nr_tag  = sizeof(ckinds);
	} else if (filetype == "java") {
		taglist = javakinds;
		nr_tag  = sizeof(javakinds);
	} else if (filetype == "matlab") {
		taglist = matlabkinds;
		nr_tag  = sizeof(matlabkinds);
	}

	for (int i = 0; i < nr_tag; i++) {
		for (auto it = dat[taglist[i]].cbegin(); it != dat[taglist[i]].cend(); ++it)
			ofs << *it << ' ';
		ofs << endl;
	}
	ofs.flush();
	ofs.close();

	return 0;
}
