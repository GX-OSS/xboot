/*
 * wboxtest/graphic/polygon.c
 */

#include <wboxtest.h>

struct wbt_polygon_pdata_t
{
	struct window_t * w;
};

static void * polygon_setup(struct wboxtest_t * wbt)
{
	struct wbt_polygon_pdata_t * pdat;

	pdat = malloc(sizeof(struct wbt_polygon_pdata_t));
	if(!pdat)
		return NULL;

	pdat->w = window_alloc(NULL, NULL);
	if(!pdat->w)
	{
		free(pdat);
		return NULL;
	}
	return pdat;
}

static void polygon_clean(struct wboxtest_t * wbt, void * data)
{
	struct wbt_polygon_pdata_t * pdat = (struct wbt_polygon_pdata_t *)data;

	if(pdat)
	{
		window_free(pdat->w);
		free(pdat);
	}
}

static void draw_polygon(struct window_t * w, void * o)
{
	struct wbt_polygon_pdata_t * pdat = (struct wbt_polygon_pdata_t *)o;
	struct surface_t * s = pdat->w->s;
	struct point_t p[10];
	struct color_t c;
	int thickness;

	int n = wboxtest_random_int(2, 10);
	for(int i = 0; i < n; i++)
	{
		p[i].x = wboxtest_random_int(0, surface_get_width(s));
		p[i].y = wboxtest_random_int(0, surface_get_height(s));
	}
	color_init(&c, rand() & 0xff, rand() & 0xff, rand() & 0xff, 255);
	thickness = wboxtest_random_int(0, 50);
	surface_shape_polygon(s, NULL, &p[0], n, thickness, &c);
}

static void polygon_run(struct wboxtest_t * wbt, void * data)
{
	struct wbt_polygon_pdata_t * pdat = (struct wbt_polygon_pdata_t *)data;
	int frame = 600;

	if(pdat)
	{
		while(frame-- > 0)
		{
			ktime_t timeout = ktime_add_ms(ktime_get(), 16);
			window_present(pdat->w, pdat, draw_polygon);
			while(ktime_before(ktime_get(), timeout));
		}
	}
}

static struct wboxtest_t wbt_polygon = {
	.group	= "graphic",
	.name	= "polygon",
	.setup	= polygon_setup,
	.clean	= polygon_clean,
	.run	= polygon_run,
};

static __init void polygon_wbt_init(void)
{
	register_wboxtest(&wbt_polygon);
}

static __exit void polygon_wbt_exit(void)
{
	unregister_wboxtest(&wbt_polygon);
}

wboxtest_initcall(polygon_wbt_init);
wboxtest_exitcall(polygon_wbt_exit);
