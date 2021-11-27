import {PythonShell} from 'python-shell';

class ImageDetector {

    async detectEdge(imageUrl: string): Promise<Object> {
        
        return new Promise((resolve, reject) => {
            try {
                PythonShell.run('src/utils/edge-detector.py', {
                    args: [imageUrl]
                }, 
                function (err, out) {
                    if (err) throw err;
                    resolve(out);
                });
            } catch(e) {
                reject(e);
            }
        });
    }
}

export const imageDetector = new ImageDetector();