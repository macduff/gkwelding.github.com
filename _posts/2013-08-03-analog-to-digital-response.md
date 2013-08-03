---
comments: true
date: 2013-08-03 15:00:00
layout: post
slug: digital-filter-specification 
title: Digital Filter Specifications 
summary: "Digital Filter Specifications"
image: 'digital-sampling/sinc.png'
tags:
- dsp
---

## Digital Filter Specification
As we began last time, here is the `help` from
the `octave` Butterworth filter specification function `butter`:

{% highlight console %}
 Generate a butterworth filter.
 Default is a discrete space (Z) filter.
 
 [b,a] = butter(n, Wc)
    low pass filter with cutoff pi{% raw %}*{% endraw %}Wc radians
{% endhighlight %}

We discussed some of the pitfalls of selecting the proper sample
time, {% raw %}<script type="math/tex">T_{s}</script>{% endraw %}.  As a
rule of thumb, one can start with 10 times faster than the fastest
frequency the expect to encounter.  Most of the time an anti-aliasing
filter will be used to guarentee that higher order harmonics will be 
successfully attenuated.  That's a subject in an of itself!

Now that we have selected our sample time we can continue our digital
filter specification.  In the above, the `butter` function expects that
the value of `Wc` is a number between 0 and 1.  This value makes up our
so called digital cutoff.

In the digital frequency domain, all bandlimited signals
that are sampled sufficiently fast, with an antialiasing filter,
well have all spectral
content between {% raw %}<script type="math/tex">-\pi</script>{% endraw %} and {% raw %}<script type="math/tex">\pi</script>{% endraw %}.  Upper and
lower frequency bounds, map
to {% raw %}<script type="math/tex">-\frac{1}{2}fs</script>{% endraw %} and  {% raw %}<script type="math/tex">\frac{1}{2}fs</script>{% endraw %}.  So in order to select a cutoff freqency we can derive the following equation.

{% raw %}
<script type="math/tex; mode=display">
W_{c} = \frac{2 f_{c}}{f_{s}}
</script>
{% endraw %}

So if we would like a first order Butterworth filter, sampled at 100 Hz
with a cutoff frequency of 15 Hz would be specified as:

{% highlight matlab %}
 fs = 100;
 fc = 15;
 n = 1;
 Wc = fc/(0.5*fs);
 [b,a] = butter(n, Wc)
{% endhighlight %}

{% raw %}
<script type="math/tex; mode=display">
H(z) = \frac{0.33754z^{-1} + 0.33754}{z^{-1} - 0.32492}
</script>
{% endraw %}


{% highlight matlab %}
[h,w] = freqz(b,a);
hh = 20*log10(h);
II = (hh < -3);
n = find(II,1,'first');
plot( 0.5*fs*(w/pi), 20*log10(h),'LineWidth',2,0.5*fs*(w(n)/pi), 20*log10(h(n)),'o','markersize',20,'LineWidth',2 )
title('Frequency Response of Butterworth Filter')
ylabel('Amplitude (dB)')
xlabel('Frequency (Hz)')
{% endhighlight %}

This will yield the following graph.

![Filter Frequency Response](/img/posts/digital-sampling/filterresp.png)

As we can see, the cutoff frequency, the -3 dB frequency, is right at
15 Hz!

