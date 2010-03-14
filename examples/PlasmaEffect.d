module examples.TrueColor;

// Plasma Effect, GiM
// compile with version=UseDListener

import PixelToastereD;

import std.math : sin, cos, PI, sqrt, abs;

const int width = 640;
const int height = 480;

alias TrueColorPixel Pixel;

class App : protected Listener {
	public:
		static App getInstance() {
			if (_inst is null) {
				_inst = new App;
			}
			return _inst;
		}

		pure
		real dist(int x1, int y1, int x2, int y2) {
			int d1 = (x1-x2), d2 = (y1-y2);
			return sqrt(cast(real)( (d1*d1) + (d2*d2) ));
		}

		void run() {
			display.open("Plasma Effect Example\0".ptr, width, height, Output.Default, Mode.TrueColor);

			for (int x = 0; x < palette.length; ++x) {
				palette[x].r = cast(ubyte)(255*(sin(x * PI /128.0)/2.0 + .5f));
				auto s = sin(x * PI /128.0);
				if (s > .5f) {
					s -= .5f;
					palette[x].g = cast(ubyte)(192*s*2.0);
				} 

				palette[x].b = cast(ubyte)(128*(cos(x * PI / 96.0)/2.0 + .5f));
			}

			size_t frame;
			const auto width_2 = width / 2;
			const auto height_2 = height / 2;

			while (display.open()) {
				size_t index = 0;

				auto p_x = cast(uint)(width_2*sin(frame * PI / 33) + width_2);
				auto p_y = cast(uint)(height_2*cos(frame * PI / 64) + height_2);
				auto palLen = 1.0 / ( (palette.length - 1.0)/4.0 );
				real idx1[width];
				for (int x = 0; x < width; ++x) {
					idx1[x] = sin( (x+3*frame) / 160.0);
				}
	
				for (int y = 0; y < height; ++y) {
					for (int x = 0; x < width; ++x) {
						auto idx2 = sin( dist(x,y, p_x, p_y) * palLen );
						auto combine = ((idx1[ x ] + idx2 + 2.0)/4.0);
						auto idx3 = cast(uint)( (palette.length - 1)*combine );
						
						pixels[index].integer = palette[ idx3 ].integer;
						++index;
					}
				}

				display.update(pixels.ptr);
				frame++;
			}
		}

	protected:
		override
		void onKeyUp(IDisplay display, Key key) { 
			if (key == Key.Q || key == Key.Escape) {
				display.close();
			}
			if (key == Key.Space) {
				doCombine = ! doCombine;
			}
		}

	private:
		this() {
			display = new Display();
			doCombine = true;
			display.listener = this;
		}

	private:
		bool doCombine;
		Display display;
		Pixel pixels[width * height];
		Pixel palette[1024];

		static App _inst;
}

int main() {
	App.getInstance.run;
	return 0;
}	

/* 
 * modeline for vim, display tabs as they'd have width 4
 * vim:ts=4:sw=4:sts=8:noexpandtab:
 */
