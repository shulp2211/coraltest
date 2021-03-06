error.bar <- function(x, y, upper, lower=upper, length=0.025, ...)
{
	if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper)) stop("vectors must be same length")
	arrows(y+upper, x, y-lower, x, angle=90, code=3, length=length, ...)
}

plot.error.bar = function(datafile, texfile, p1, p2, p3, title, leftmargin, flag)
{
	data = read.table(datafile);
	n = length(data[,1]);
	library(tikzDevice);
	tikz(texfile, width = 4.2 + leftmargin, height = 0.6 + 0.5 * n);

	xx = matrix(nrow = 3, ncol = n);
	ee = matrix(nrow = 3, ncol = n);
	xx[1,] = t(data[n:1,p1]);
	xx[2,] = t(data[n:1,p2]);
	xx[3,] = t(data[n:1,p3]);
	ee[1,] = t(data[n:1,p1 + 1]);
	ee[2,] = t(data[n:1,p2 + 1]);
	ee[3,] = t(data[n:1,p2 + 1]);
	maxvalue1 = max(xx[1,] + 0 * ee[1,]) * 1.05;
	maxvalue2 = max(xx[2,] + 0 * ee[2,]) * 1.05;
	maxvalue3 = max(xx[3,] + 0 * ee[3,]) * 1.05;
	maxvalue = max(maxvalue1, maxvalue2, maxvalue3);

	par(oma = c(0, 0, 0, 0))
	par(mai=c(0.0,leftmargin,0.6,0.0));

	barx = barplot(xx, horiz=TRUE, beside=TRUE, col=c(4,2,6), xaxt = 'n', yaxt = 'n', xlim = c(0, maxvalue));
#error.bar(barx, xx, ee);
	axis(3, mgp = c(0, 0.6, 0), pos = n * 4 + 1);
	axis(3, tick = FALSE, pos = n * 4 + 2.5, at = c(maxvalue * 0.45), labels = c(title));

	axis(2, tick = FALSE, las = 1, at = c(1:n) * 4 - 1.5, labels = t(data[n:1,1]), mgp = c(0, 0.3, 0));

	px = maxvalue * 1.02;
	py = n * 4 + 1.0;

	if(flag > 0)
	{
		legend(px, py, c("Coral w/ ref.", "Coral w/o ref.", "w/o Coral"), col = c(6,2,4), fill = c(6,2,4), bty='n', cex = 1, xjust = 1, x.intersp = 0.5);
	}
	dev.off();
}
