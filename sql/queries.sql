SELECT COUNT(*) FROM dim_ativo;
SELECT COUNT(*) FROM dim_data;
SELECT COUNT(*) FROM fato_cotacao;


SELECT *
FROM dim_ativo;


SELECT
    a.codigo,
    a.nome,
    f.fonte,
    ROUND(MAX(f.retorno_acumulado)::numeric * 100, 2) AS retorno_percentual
FROM fato_cotacao f
JOIN dim_ativo a ON a.ativo_id = f.ativo_id
GROUP BY a.codigo, a.nome, f.fonte
ORDER BY retorno_percentual DESC;


SELECT
    a.codigo,
    a.nome,
    f.fonte,
    ROUND(AVG(f.volatilidade_7d)::numeric * 100, 2) AS volatilidade_media
FROM fato_cotacao f
JOIN dim_ativo a ON a.ativo_id = f.ativo_id
WHERE f.volatilidade_7d IS NOT NULL
GROUP BY a.codigo, a.nome, f.fonte
ORDER BY volatilidade_media DESC;


SELECT
    a.codigo,
    a.nome,
    f.fonte,
    ROUND(
        MAX(f.retorno_acumulado)::numeric /
        NULLIF(AVG(f.volatilidade_7d)::numeric, 0),
        4
    ) AS score_retorno_risco
FROM fato_cotacao f
JOIN dim_ativo a ON a.ativo_id = f.ativo_id
WHERE f.volatilidade_7d IS NOT NULL
GROUP BY a.codigo, a.nome, f.fonte
ORDER BY score_retorno_risco DESC;