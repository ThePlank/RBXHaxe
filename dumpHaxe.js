const rimraf = require('rimraf');
const fs = require('fs');

const haxeLibDir = "rbxhaxe";

async function dumpClassFiles(classes) {
	for (let i = 0; i < classes.length; i++) {
		let stream = classes[i].getReadStream();
		let name = classes[i].Name;

		let file = fs.createWriteStream('./' + haxeLibDir + '/' + name + '.hx');
		stream.pipe(file);
	}
}

async function dumpEnumFiles(enums) { 
	for (let i = 0; i < enums.length; i++) {
		let stream = enums[i].getReadStream();
		let name = enums[i].Name;

		let file = fs.createWriteStream('./' + haxeLibDir + '/enums/' + name + '.hx');
		stream.pipe(file);
	}
}

async function dumpClasses(classes, enums){
	rimraf(haxeLibDir, (error) => {
		if(error !== null) {
			throw error;
			return;
		}

		fs.mkdir(haxeLibDir, (error) =>  {
			if(error !== null) {
				throw error;
				return;
			}
			dumpClassFiles(classes);
		});

		fs.mkdir(`${haxeLibDir}/enums`, (error) =>   {
			if(error !== null) {
				throw error;
				return;
			}
			dumpEnumFiles(enums);
		});
	});
}

module.exports = dumpClasses;