import { useState } from "react";
import { Typography, Button, Box } from "@mui/material";

type ShowMoreProps = {
  text: string;
  maxLength: number;
  children?: React.ReactNode; // Optional children prop
};

const ShowMore: React.FC<ShowMoreProps> = ({
  text,
  maxLength,
}: {
  text: string;
  maxLength: number;
}) => {
  const [isExpanded, setIsExpanded] = useState(false);

  const toggleExpand = () => {
    setIsExpanded(!isExpanded);
  };

  const displayedText =
    isExpanded || text.length < maxLength
      ? text
      : `${text.slice(0, maxLength)}...`;

  return (
    <Box>
      <Typography variant="body1" paragraph>
        {displayedText}
      </Typography>
      {text.length < maxLength ? null : (
        <Button color="secondary" onClick={toggleExpand}>
          {isExpanded ? "Mostrar menos" : "Mostrar Más"}
        </Button>
      )}
    </Box>
  );
};

export default ShowMore;
